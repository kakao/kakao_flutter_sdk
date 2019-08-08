import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_context.dart';

import 'package:platform/platform.dart';

class AuthApi {
  AuthApi(this.dio, [this.platform]);

  final Dio dio;
  final Platform platform;
  static final AuthApi instance = AuthApi(ApiFactory.kauthApi, LocalPlatform());

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

  Future<Map<String, String>> _platformData() async {
    var origin = await KakaoContext.origin;
    return platform.isAndroid
        ? {"android_key_hash": origin}
        : platform.isIOS ? {"ios_bundle_id": origin} : {};
  }

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
      Response response = await dio.post("/oauth/token", data: data);
      return AccessTokenResponse.fromJson(response.data);
    });
  }
}
