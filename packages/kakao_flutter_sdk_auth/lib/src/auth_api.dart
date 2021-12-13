import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api_factory.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';
import 'package:kakao_flutter_sdk_auth/src/model/cert_token_info.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

class AuthApi {
  AuthApi(
      {Dio? dio,
      Platform? platform,
      TokenManagerProvider? tokenManagerProvider})
      : _dio = dio ?? AuthApiFactory.kauthApi,
        _platform = platform ?? LocalPlatform(),
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
    return token == null;
  }

  /// 사용자 인증코드([authCode])를 이용하여 신규 토큰 발급을 요청합니다.
  /// [codeVerifier]는 사용자 인증 코드 verifier로 사용합니다.
  Future<OAuthToken> issueAccessToken(String authCode,
      {String? redirectUri, String? appKey, String? codeVerifier}) async {
    final data = {
      "code": authCode,
      "grant_type": "authorization_code",
      "client_id": appKey ?? KakaoSdk.platformAppKey,
      "redirect_uri": redirectUri ?? await _platformRedirectUri(),
      "code_verifier": codeVerifier,
      ...await _platformData()
    };
    return await _issueAccessToken(data);
  }

  /// @nodoc
  /// Internal Only
  Future<CertTokenInfo> issueAccessTokenWithCert(String authCode,
      {String? redirectUri, String? appKey, String? codeVerifier}) async {
    final data = {
      "code": authCode,
      "grant_type": "authorization_code",
      "client_id": appKey ?? KakaoSdk.platformAppKey,
      "redirect_uri": redirectUri ?? await _platformRedirectUri(),
      "code_verifier": codeVerifier,
      ...await _platformData()
    };
    return await _issueAccessTokenWithCert(data);
  }

  /// 기존 토큰([oldToken])을 갱신합니다
  Future<OAuthToken> refreshAccessToken(OAuthToken oldToken,
      {String? redirectUri, String? appKey}) async {
    final data = {
      "refresh_token": oldToken.refreshToken,
      "grant_type": "refresh_token",
      "client_id": appKey ?? KakaoSdk.platformAppKey,
      "redirect_uri": redirectUri ?? await _platformRedirectUri(),
      ...await _platformData()
    };
    final newToken = await _issueAccessToken(data, oldToken: oldToken);
    await _tokenManagerProvider.manager.setToken(newToken);
    return newToken;
  }

  /// @nodoc
  Future<String> agt({String? appKey, String? accessToken}) async {
    final tokenInfo = await _tokenManagerProvider.manager.getToken();
    final data = {
      "client_id": appKey ?? KakaoSdk.platformAppKey,
      "access_token": accessToken ?? tokenInfo!.accessToken
    };

    return await ApiFactory.handleApiError(() async {
      final response = await _dio.post("/api/agt", data: data);
      return response.data["agt"];
    });
  }

  Future<OAuthToken> _issueAccessToken(data, {OAuthToken? oldToken}) async {
    return await ApiFactory.handleApiError(() async {
      Response response = await _dio.post("/oauth/token", data: data);
      final tokenResponse = AccessTokenResponse.fromJson(response.data);
      return OAuthToken.fromResponse(tokenResponse, oldToken: oldToken);
    });
  }

  Future<CertTokenInfo> _issueAccessTokenWithCert(data) async {
    return await ApiFactory.handleApiError(() async {
      Response response = await _dio.post("/oauth/token", data: data);
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
    if (kIsWeb) return {"client_origin": origin};
    return _platform.isAndroid
        ? {"android_key_hash": origin}
        : _platform.isIOS
            ? {"ios_bundle_id": origin}
            : {};
  }

  Future<String> _platformRedirectUri() async {
    if (kIsWeb) return await KakaoSdk.origin;
    return "kakao${KakaoSdk.nativeKey}://oauth";
  }
}
