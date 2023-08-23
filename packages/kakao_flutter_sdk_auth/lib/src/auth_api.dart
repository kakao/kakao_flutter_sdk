import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api_factory.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';
import 'package:kakao_flutter_sdk_auth/src/model/cert_token_info.dart';
import 'package:kakao_flutter_sdk_auth/src/model/cert_type.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:platform/platform.dart';

/// Kakao SDK의 카카오 로그인 내부 동작에 사용되는 클라이언트
class AuthApi {
  AuthApi({
    Dio? dio,
    Platform? platform,
    TokenManagerProvider? tokenManagerProvider,
  })  : _dio = dio ?? AuthApiFactory.kauthApi,
        _platform = platform ?? const LocalPlatform(),
        _tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  final Dio _dio;
  final Platform _platform;

  /// @nodoc
  final TokenManagerProvider _tokenManagerProvider;

  static final AuthApi instance = AuthApi();

  /// 사용자가 앞서 로그인을 통해 토큰을 발급 받은 상태인지 확인합니다.
  /// 주의: 기존 토큰 존재 여부를 확인하는 기능으로, 사용자가 현재도 로그인 상태임을 보장하지 않습니다.
  Future<bool> hasToken() async {
    final token = await _tokenManagerProvider.manager.getToken();
    return token != null;
  }

  /// 사용자 인증코드([authCode])를 이용하여 신규 토큰 발급을 요청합니다.
  /// [codeVerifier]는 사용자 인증 코드 verifier로 사용합니다.
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
  // Internal Only
  Future<CertTokenInfo> issueAccessTokenWithCert({
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
    return await _issueAccessTokenWithCert(data);
  }

  /// 기존 토큰([oldToken])을 갱신합니다.
  Future<OAuthToken> refreshToken({
    OAuthToken? oldToken,
    String? redirectUri,
    String? appKey,
  }) async {
    var token = oldToken ?? await _tokenManagerProvider.manager.getToken();

    if (token == null || token.refreshToken == null) {
      throw KakaoClientException(
          'Refresh token not found. You must login first.');
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

  /// 기존 토큰([oldToken])을 갱신합니다.
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
          'Token registered in TokenManager does not exist!');
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

  Future<String> prepare({
    required CertType certType,
    String? settleId,
    String? signData,
    String? txId,
  }) async {
    var data = {
      'client_id': KakaoSdk.appKey,
      'settle_id': settleId,
      'sign_data': signData,
      'tx_id': txId,
      'cert_type': certType.name,
    };
    data.removeWhere((k, v) => v == null);

    return await ApiFactory.handleApiError(() async {
      final response = await _dio.post(Constants.preparePath, data: data);
      return response.data['kauth_tx_id'];
    });
  }

  Future<OAuthToken> _issueAccessToken(data, {OAuthToken? oldToken}) async {
    return await ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.tokenPath, data: data);
      final tokenResponse = AccessTokenResponse.fromJson(response.data);
      return OAuthToken.fromResponse(tokenResponse, oldToken: oldToken);
    });
  }

  Future<CertTokenInfo> _issueAccessTokenWithCert(data) async {
    return await ApiFactory.handleApiError(() async {
      Response response = await _dio.post(Constants.tokenPath, data: data);
      final tokenResponse = AccessTokenResponse.fromJson(response.data);
      if (tokenResponse.txId == null) {
        throw KakaoClientException('txId is null');
      }
      return CertTokenInfo(
          OAuthToken.fromResponse(tokenResponse), tokenResponse.txId!);
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
