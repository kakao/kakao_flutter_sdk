import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:platform/platform.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  late Dio _dio;
  late MockAdapter _adapter;
  late AuthApi _authApi;
  late TokenManager _tokenManager;

  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('kakao_flutter_sdk');

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _dio.interceptors.add(ApiFactory.kaInterceptor);
    _dio.options.baseUrl = "https://${KakaoContext.hosts.kauth}";
    _authApi = AuthApi(dio: _dio);
    _tokenManager = DefaultTokenManager();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return "sample_origin";
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  group("/oauth/token 200", () {
    var map;
    AccessTokenResponse response;
    setUp(() async {
      String body = await loadJson("oauth/token_with_rt_and_scopes.json");
      map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      response = await _authApi.issueAccessToken("auth_code",
          redirectUri: "kakaosample_app_key://oauth",
          clientId: "sample_app_key");
      expect(response.accessToken, map["access_token"]);
      expect(response.refreshToken, map["refresh_token"]);
      expect(response.expiresIn, map["expires_in"]);
      expect(response.refreshTokenExpiresIn, map["refresh_token_expires_in"]);
      expect(response.scopes, map["scope"]);

      expect(map, response.toJson());
    });
    test('on android', () async {
      _authApi = AuthApi(
          dio: _dio, platform: FakePlatform(operatingSystem: "android"));
    });

    test("on ios", () async {
      _authApi =
          AuthApi(dio: _dio, platform: FakePlatform(operatingSystem: "ios"));
    });
  });

  test('/oauth/token 400', () async {
    String body = await loadJson("errors/misconfigured.json");
    _adapter.setResponseString(body, 401);
    try {
      await _authApi.issueAccessToken("authCode",
          redirectUri: "kakaosample_app_key://oauth",
          clientId: "sample_app_key");
      fail("Should not reach here");
    } on KakaoAuthException catch (e) {
      expect(e.error, AuthErrorCause.MISCONFIGURED);
      expect(true, e.toJson() != null);
    } catch (e) {
      expect(e, isInstanceOf<KakaoAuthException>());
    }
  });

  group("/oauth/token refresh access token only", () {
    var map;
    var refreshToken = "test_refresh_token";
    var redirectUri = "kakaosample_app_key://oauth";
    var clientId = "sample_app_key";

    setUp(() async {
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{}; // set initial values here if desired
        }
        if (methodCall.method.startsWith("set") ||
            methodCall.method == 'remove') {
          return true;
        }
        return null;
      });

      String body = await loadJson("oauth/token.json");
      map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      // setting oldToken
      var tokenJson = await loadJson("oauth/token_with_rt_and_scopes.json");
      var tokenResponse = AccessTokenResponse.fromJson(jsonDecode(tokenJson));
      final oldToken = await _tokenManager.setToken(tokenResponse);

      var newToken = await _authApi.refreshAccessToken(refreshToken,
          redirectUri: redirectUri, clientId: clientId);
      expect(true, oldToken.accessToken != newToken.accessToken);
      expect(
          true, oldToken.accessTokenExpiresAt != newToken.accessTokenExpiresAt);
      expect(true, oldToken.refreshToken == newToken.refreshToken);
      expect(true,
          oldToken.refreshTokenExpiresAt == newToken.refreshTokenExpiresAt);
      expect(true, listEquals(oldToken.scopes, newToken.scopes));
    });

    test("on android", () async {
      _authApi = AuthApi(
          dio: _dio, platform: FakePlatform(operatingSystem: "android"));
      _adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/oauth/token");
        Map<String, dynamic> params = options.data;
        expect(params.length, 5);
        expect(params["refresh_token"], refreshToken);
        expect(params["redirect_uri"], redirectUri);
        expect(params["client_id"], clientId);
        expect(params["android_key_hash"], "sample_origin");
      };
    });
    test("on ios", () async {
      _authApi =
          AuthApi(dio: _dio, platform: FakePlatform(operatingSystem: "ios"));
      _adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/oauth/token");
        Map<String, dynamic> params = options.data;
        expect(params.length, 5);
        expect(params["refresh_token"], refreshToken);
        expect(params["redirect_uri"], redirectUri);
        expect(params["client_id"], clientId);
        expect(params["ios_bundle_id"], "sample_origin");
      };
    });
  });

  test(
      "/oauth/token 400 with wrong enum value and missing description should have both fields as null",
      () async {
    String body = jsonEncode({"error": "invalid_credentials"});
    _adapter.setResponseString(body, 401);
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
  });

  group("/oauth/token refresh access token and refresh token", () {
    var map;
    var refreshToken = "test_refresh_token";
    var redirectUri = "kakaosample_app_key://oauth";
    var clientId = "sample_app_key";

    setUp(() async {
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{}; // set initial values here if desired
        }
        if (methodCall.method.startsWith("set") ||
            methodCall.method == 'remove') {
          return true;
        }
        return null;
      });

      String body = await loadJson("oauth/token_with_rt.json");
      map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      // setting oldToken
      var tokenJson = await loadJson("oauth/token_with_rt_and_scopes.json");
      var tokenResponse = AccessTokenResponse.fromJson(jsonDecode(tokenJson));
      final oldToken = await _tokenManager.setToken(tokenResponse);

      var newToken = await _authApi.refreshAccessToken(refreshToken,
          redirectUri: redirectUri, clientId: clientId);
      expect(true, oldToken.accessToken != newToken.accessToken);
      expect(
          true, oldToken.accessTokenExpiresAt != newToken.accessTokenExpiresAt);
      expect(true, oldToken.refreshToken != newToken.refreshToken);
      expect(true,
          oldToken.refreshTokenExpiresAt != newToken.refreshTokenExpiresAt);
      expect(true, listEquals(oldToken.scopes, newToken.scopes));
    });

    test("on android", () async {
      _authApi = AuthApi(
          dio: _dio, platform: FakePlatform(operatingSystem: "android"));
      _adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/oauth/token");
        Map<String, dynamic> params = options.data;
        expect(params.length, 5);
        expect(params["refresh_token"], refreshToken);
        expect(params["redirect_uri"], redirectUri);
        expect(params["client_id"], clientId);
        expect(params["android_key_hash"], "sample_origin");
      };
    });
    test("on ios", () async {
      _authApi =
          AuthApi(dio: _dio, platform: FakePlatform(operatingSystem: "ios"));
      _adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/oauth/token");
        Map<String, dynamic> params = options.data;
        expect(params.length, 5);
        expect(params["refresh_token"], refreshToken);
        expect(params["redirect_uri"], redirectUri);
        expect(params["client_id"], clientId);
        expect(params["ios_bundle_id"], "sample_origin");
      };
    });
  });
}
