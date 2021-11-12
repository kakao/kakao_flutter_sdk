import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/auth/model/cert_token_info.dart';
import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';
import 'package:kakao_flutter_sdk/src/auth/token_manager.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_context.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';
import 'package:platform/platform.dart';

/// Provides Kakao OAuth API.
class AuthApi {
  AuthApi(
      {Dio? dio,
      Platform? platform,
      TokenManagerProvider? tokenManagerProvider})
      : _dio = dio ?? ApiFactory.kauthApi,
        _platform = platform ?? LocalPlatform(),
        _tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  final Dio _dio;
  final Platform _platform;
  final TokenManagerProvider _tokenManagerProvider;

  /// Default instance SDK provides.
  static final AuthApi instance = AuthApi();

  /// Check OAuthToken is issued.
  Future<bool> hasToken() async {
    final token = await _tokenManagerProvider.manager.getToken();
    return token == null;
  }

  /// Issues an access token from authCode acquired from [AuthCodeClient].
  Future<OAuthToken> issueAccessToken(String authCode,
      {String? redirectUri, String? clientId, String? codeVerifier}) async {
    final data = {
      "code": authCode,
      "grant_type": "authorization_code",
      "client_id": clientId ?? KakaoContext.platformClientId,
      "redirect_uri": redirectUri ?? await _platformRedirectUri(),
      "code_verifier": codeVerifier,
      ...await _platformData()
    };
    return await _issueAccessToken(data);
  }

  /// Issues an access token from authCode acquired from [AuthCodeClient].
  Future<CertTokenInfo> issueAccessTokenWithCert(String authCode,
      {String? redirectUri, String? clientId, String? codeVerifier}) async {
    final data = {
      "code": authCode,
      "grant_type": "authorization_code",
      "client_id": clientId ?? KakaoContext.platformClientId,
      "redirect_uri": redirectUri ?? await _platformRedirectUri(),
      "code_verifier": codeVerifier,
      ...await _platformData()
    };
    return await _issueAccessTokenWithCert(data);
  }

  /// Issues a new access token from the given refresh token.
  ///
  /// Refresh tokens are usually retrieved from [TokenManager].
  Future<OAuthToken> refreshAccessToken(OAuthToken oldToken,
      {String? redirectUri, String? clientId}) async {
    final data = {
      "refresh_token": oldToken.refreshToken,
      "grant_type": "refresh_token",
      "client_id": clientId ?? KakaoContext.platformClientId,
      "redirect_uri": redirectUri ?? await _platformRedirectUri(),
      ...await _platformData()
    };
    final newToken = await _issueAccessToken(data, oldToken: oldToken);
    await _tokenManagerProvider.manager.setToken(newToken);
    return newToken;
  }

  /// Issues temporary agt (access token-generated token), which can be used to acquire auth code.
  Future<String> agt({String? clientId, String? accessToken}) async {
    final tokenInfo = await _tokenManagerProvider.manager.getToken();
    final data = {
      "client_id": clientId ?? KakaoContext.platformClientId,
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
    final origin = await KakaoContext.origin;
    if (kIsWeb) return {"client_origin": origin};
    return _platform.isAndroid
        ? {"android_key_hash": origin}
        : _platform.isIOS
            ? {"ios_bundle_id": origin}
            : {};
  }

  Future<String> _platformRedirectUri() async {
    if (kIsWeb) return await KakaoContext.origin;
    return "kakao${KakaoContext.clientId}://oauth";
  }
}
