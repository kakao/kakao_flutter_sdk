import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api_factory.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:platform/platform.dart';

/// KO: 카카오 로그인 인증 및 토큰 관리 클래스
/// <br>
/// EN: Class for the authentication and token management through Kakao Login
class AuthApi {

  final Dio _dio;
  final Platform _platform;

  final TokenManagerProvider _tokenManagerProvider;
  static final AuthApi instance = AuthApi();

  /// @nodoc
  AuthApi({
    Dio? dio,
    Platform? platform,
    TokenManagerProvider? tokenManagerProvider,
  })  : _dio = dio ?? AuthApiFactory.kauthApi,
        _platform = platform ?? const LocalPlatform(),
        _tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  /// KO: 토큰 존재 여부 확인하기
  /// <br>
  /// EN: Check token presence
  Future<bool> hasToken() async {
    final token = await _tokenManagerProvider.manager.getToken();
    return token != null;
  }

  /// @nodoc
  Future<OAuthToken> issueAccessToken({
    required String authCode,
    String? redirectUri,
    String? appKey,
    String? codeVerifier,
  }) async {
    final data = {
      Constants.code: authCode,
      Constants.grantType: Constants.authorizationCode,
      Constants.clientId: appKey ?? KakaoSdk.appKey,
      Constants.redirectUri: redirectUri ?? await _platformRedirectUri(),
      Constants.codeVerifier: codeVerifier,
      ...await _platformData()
    };
    data.removeWhere((k, v) => v == null);
    return await _issueAccessToken(data);
  }

  /// @nodoc
  Future<OAuthToken> refreshToken({
    OAuthToken? oldToken,
    String? redirectUri,
    String? appKey,
  }) async {
    var token = oldToken ?? await _tokenManagerProvider.manager.getToken();

    if (token == null || token.refreshToken == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'Refresh token not found. You must login first.',
      );
    }

    final data = {
      Constants.refreshToken: token.refreshToken,
      Constants.grantType: Constants.refreshToken,
      Constants.clientId: appKey ?? KakaoSdk.appKey,
      Constants.redirectUri: redirectUri ?? await _platformRedirectUri(),
      ...await _platformData()
    };
    final newToken = await _issueAccessToken(data, oldToken: oldToken);
    await _tokenManagerProvider.manager.setToken(newToken);
    return newToken;
  }

  /// @nodoc
  @Deprecated('This method is replaced with \'AuthApi#refreshToken\'')
  Future<OAuthToken> refreshAccessToken({
    required OAuthToken oldToken,
    String? redirectUri,
    String? appKey,
  }) async {
    return await refreshToken(
        oldToken: oldToken, redirectUri: redirectUri, appKey: appKey);
  }

  /// @nodoc
  Future<String> agt({String? appKey, String? accessToken}) async {
    final tokenInfo = await _tokenManagerProvider.manager.getToken();
    if (accessToken == null && tokenInfo == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'Token registered in TokenManager does not exist!',
      );
    }
    final data = {
      Constants.clientId: appKey ?? KakaoSdk.appKey,
      Constants.accessToken: accessToken ?? tokenInfo!.accessToken
    };

    return await ApiFactory.handleApiError(() async {
      final response = await _dio.post(Constants.agtPath, data: data);
      return response.data[Constants.agt];
    });
  }

  /// @nodoc
  Future<String> codeForWeb({
    required String stateToken,
    required String kaHeader,
  }) async {
    var queryParams = {
      'client_id': KakaoSdk.appKey,
      'auth_tran_id': stateToken,
      'ka': kaHeader,
    };

    return await ApiFactory.handleApiError(() async {
      var response = await _dio.get(Constants.apiWebCodeJson,
          queryParameters: queryParams);

      if (response.data.toString().contains('error')) {
        return 'error';
      }
      return response.data['code'];
    });
  }

  Future<OAuthToken> _issueAccessToken(data, {OAuthToken? oldToken}) async {
    return await ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.tokenPath, data: data);
      final tokenResponse = AccessTokenResponse.fromJson(response.data);
      return OAuthToken.fromResponse(tokenResponse, oldToken: oldToken);
    });
  }

  Future<Map<String, String>> _platformData() async {
    final origin = await KakaoSdk.origin;
    if (kIsWeb) return {Constants.clientOrigin: origin};
    return _platform.isAndroid
        ? {Constants.androidKeyHash: origin}
        : _platform.isIOS
            ? {Constants.iosBundleId: origin}
            : {};
  }

  Future<String> _platformRedirectUri() async {
    if (kIsWeb) return await KakaoSdk.origin;
    return KakaoSdk.redirectUri;
  }
}
