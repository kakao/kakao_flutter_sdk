import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:kakao_flutter_sdk/src/api_factory.dart';
import 'package:kakao_flutter_sdk/src/constants.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_auth_exception.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  Dio _dio;
  MockAdapter _adapter;
  AuthApi _authApi;

  const MethodChannel channel = MethodChannel('kakao_flutter_sdk');

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _dio.interceptors.add(ApiFactory.kaInterceptor);
    _dio.options.baseUrl = OAUTH_HOST;
    _authApi = AuthApi(_dio);
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return "sample_origin";
    });
  });
  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('/oauth/token 200', () async {
    String body = await loadJson("auth/token_with_rt_and_scopes.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponseString(body, 200);
    var response = await _authApi.issueAccessToken("auth_code",
        redirectUri: "kakaosample_app_key://oauth", clientId: "sample_app_key");
    expect(response.accessToken, map["access_token"]);
    expect(response.refreshToken, map["refresh_token"]);
    expect(response.expiresIn, map["expires_in"]);
    expect(response.refreshTokenExpiresIn, map["refresh_token_expires_in"]);
    expect(response.scopes, map["scope"]);
  });

  test('/oauth/token 400', () async {
    String body = await loadJson("auth/misconfigured.json");
    _adapter.setResponse(ResponseBody.fromString(body, 401));
    try {
      await _authApi.issueAccessToken("authCode",
          redirectUri: "kakaosample_app_key://oauth",
          clientId: "sample_app_key");
      fail("Should not reach here");
    } on KakaoAuthException catch (e) {
      expect(e.error, AuthErrorCause.MISCONFIGURED);
    } catch (e) {
      expect(e, isInstanceOf<KakaoAuthException>());
    }
  });

  test(
      "/oauth/token 400 with wrong enum value and missing description should have both fields as null",
      () async {
    String body = jsonEncode({"error": "invalid_credentials"});
    _adapter.setResponse(ResponseBody.fromString(body, 401));
    try {
      await _authApi.issueAccessToken("authCode",
          redirectUri: "kakaosample_app_key://oauth",
          clientId: "sample_app_key");
      fail("Should not reach here");
    } on KakaoAuthException catch (e) {
      expect(e.error, AuthErrorCause.UNKNOWN);
    } catch (e) {
      expect(e, isInstanceOf<KakaoAuthException>());
    }
  },
      skip:
          "Json_serializable currently does not support deserializing unsupported enum values.");
}
