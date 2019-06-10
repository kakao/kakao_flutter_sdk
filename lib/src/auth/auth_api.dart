import 'dart:async';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/api_factory.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';

import 'package:kakao_flutter_sdk/src/constants.dart';
import 'package:kakao_flutter_sdk/src/kakao_context.dart';

class AuthApi {
  AuthApi(this.dio);

  final Dio dio;

  static final AuthApi instance = AuthApi(ApiFactory.kauthApi);

  Future<AccessTokenResponse> issueAccessToken(String authCode,
      {String redirectUri, String clientId}) async {
    return await _issueAccessToken({
      "code": authCode,
      "grant_type": "authorization_code",
      "client_id": clientId ?? KakaoContext.clientId,
      "redirect_uri": redirectUri ?? "kakao${KakaoContext.clientId}://oauth",
      "android_key_hash": await KakaoContext.origin,
    });
  }

  Future<AccessTokenResponse> refreshAccessToken(String refreshToken,
      {String redirectUri, String clientId}) async {
    return await _issueAccessToken({
      "refresh_token": refreshToken,
      "grant_type": "refresh_token",
      "client_id": clientId ?? KakaoContext.clientId,
      "redirect_uri": redirectUri ?? "kakao:${KakaoContext.clientId}://oauth",
      "android_key_hash": await KakaoContext.origin
    });
  }

  Future<AccessTokenResponse> _issueAccessToken(data) async {
    return await ApiFactory.handleApiError(() async {
      print(data);
      Response response = await dio.post("$OAUTH_HOST/oauth/token", data: data);
      return AccessTokenResponse.fromJson(response.data);
    });
  }
}
