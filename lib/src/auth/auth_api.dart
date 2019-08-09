import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_context.dart';

import 'package:platform/platform.dart';

/// Provides Kakao OAuth API.
class AuthApi {
  AuthApi(this._dio, [this._platform]);

  final Dio _dio;
  final Platform _platform;
  static final AuthApi instance = AuthApi(ApiFactory.kauthApi, LocalPlatform());

  /// Issues an access token from authCode acquired from [AuthCodeClient].
  Future<AccessTokenResponse> issueAccessToken(String authCode,
      {String redirectUri, String clientId}) async {
    var data = {
      "code": authCode,
      "grant_type": "authorization_code",
      "client_id": clientId ?? KakaoContext.clientId,
      "redirect_uri": redirectUri ?? "kakao${KakaoContext.clientId}://oauth",
      ...await _platformData()
    };
    return await _issueAccessToken(data);
  }

  /// Issues a new access token from the given refresh token.
  ///
  /// Refresh tokens are usually retrieved from [AccessTokenRepo].
  Future<AccessTokenResponse> refreshAccessToken(String refreshToken,
      {String redirectUri, String clientId}) async {
    var data = {
      "refresh_token": refreshToken,
      "grant_type": "refresh_token",
      "client_id": clientId ?? KakaoContext.clientId,
      "redirect_uri": redirectUri ?? "kakao:${KakaoContext.clientId}://oauth",
      ...await _platformData()
    };
    return await _issueAccessToken(data);
  }

  Future<AccessTokenResponse> _issueAccessToken(data) async {
    return await ApiFactory.handleApiError(() async {
      Response response = await _dio.post("/oauth/token", data: data);
      return AccessTokenResponse.fromJson(response.data);
    });
  }

  Future<Map<String, String>> _platformData() async {
    var origin = await KakaoContext.origin;
    return _platform.isAndroid
        ? {"android_key_hash": origin}
        : _platform.isIOS ? {"ios_bundle_id": origin} : {};
  }
}
