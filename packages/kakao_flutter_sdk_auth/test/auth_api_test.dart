import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:platform/platform.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';
import 'test_double.dart';

void main() {
  late Dio dio;
  late MockAdapter adapter;
  late AuthApi authApi;
  late TokenManager tokenManager;

  var appKey = "sample_app_key";
  KakaoSdk.init(nativeAppKey: appKey);

  TestWidgetsFlutterBinding.ensureInitialized();
  registerMockMethodChannel();

  DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 12);
  DateTime refreshTokenExpiresAt = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 24 * 30 * 2);

  setUp(() {
    dio = Dio();
    adapter = MockAdapter();
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(ApiFactory.kaInterceptor);
    dio.options.baseUrl = "https://${KakaoSdk.hosts.kauth}";
    authApi = AuthApi(dio: dio);
    tokenManager = TestTokenManager(testOAuthToken(
      expiresAt: expiresAt,
      refreshTokenExpiresAt: refreshTokenExpiresAt,
    ));
    TokenManagerProvider.instance.manager = tokenManager;
  });

  group("/oauth/token 200", () {
    OAuthToken token;
    setUp(() async {
      final path = uriPathToFilePath(Constants.tokenPath);
      String body = await loadJson("auth/$path/has_rt_and_scopes.json");
      adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      // before checking token, clear tokenManager
      await tokenManager.clear();

      token = await authApi.issueAccessToken(
          authCode: "auth_code",
          redirectUri: "kakaosample_app_key://oauth",
          appKey: "sample_app_key");
      await tokenManager.setToken(token);
      final newToken = await tokenManager.getToken();
      expect(true, newToken != null);
      expect(true, token.accessToken == newToken!.accessToken);
      expect(true, token.expiresAt == newToken.expiresAt);
      expect(true, token.refreshToken == newToken.refreshToken);
      expect(
          true, token.refreshTokenExpiresAt == newToken.refreshTokenExpiresAt);
      expect(true, listEquals(token.scopes, newToken.scopes));
    });
    test('on android', () async {
      authApi =
          AuthApi(dio: dio, platform: FakePlatform(operatingSystem: "android"));
    });

    test("on ios", () async {
      authApi =
          AuthApi(dio: dio, platform: FakePlatform(operatingSystem: "ios"));
    });
  });

  test('oauth_token without refresh_token - web spec', () async {
    final path = uriPathToFilePath(Constants.tokenPath);
    String body = await loadJson("auth/$path/no_rt.json");
    adapter.setResponseString(body, 200);
    try {
      await authApi.issueAccessToken(
          authCode: "authCode",
          redirectUri: "kakaosample_app_key://oauth",
          appKey: "sample_app_key");
    } catch (e) {
      fail("Should not reach here");
    }
  });

  group("/oauth/token refresh access token only", () {
    var refreshToken = "iMpaTTZe8sAQWpgBDWPGcvN1_tJR24QVcdAcHgopdtYAAAFi_FnbLA";
    var redirectUri = "kakaosample_app_key://oauth";

    setUp(() async {
      final path = uriPathToFilePath(Constants.tokenPath);
      String body = await loadJson('auth/$path/no_rt.json');
      adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      // setting oldToken
      final path = uriPathToFilePath(Constants.tokenPath);
      var tokenJson = await loadJson("auth/$path/has_rt_and_scopes.json");
      var tokenResponse = AccessTokenResponse.fromJson(jsonDecode(tokenJson));
      await tokenManager.setToken(OAuthToken.fromResponse(tokenResponse));
      final oldToken = await tokenManager.getToken();

      expect(true, oldToken != null);

      var newToken = await authApi.refreshToken(
          oldToken: oldToken!, redirectUri: redirectUri, appKey: appKey);

      expect(true, oldToken.accessToken != newToken.accessToken);
      expect(true, oldToken.expiresAt != newToken.expiresAt);
      expect(true, oldToken.refreshToken == newToken.refreshToken);
      expect(true,
          oldToken.refreshTokenExpiresAt == newToken.refreshTokenExpiresAt);
      expect(true, listEquals(oldToken.scopes, newToken.scopes));
    });

    test("on android", () async {
      authApi =
          AuthApi(dio: dio, platform: FakePlatform(operatingSystem: "android"));
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/oauth/token");
        Map<String, dynamic> params = options.data;
        expect(params.length, 5);
        expect(params["refresh_token"], refreshToken);
        expect(params["redirect_uri"], redirectUri);
        expect(params["client_id"], appKey);
        expect(params["android_key_hash"], "sample_origin");
      };
    });

    test("on ios", () async {
      authApi =
          AuthApi(dio: dio, platform: FakePlatform(operatingSystem: "ios"));
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/oauth/token");
        Map<String, dynamic> params = options.data;
        expect(params.length, 5);
        expect(params["refresh_token"], refreshToken);
        expect(params["redirect_uri"], redirectUri);
        expect(params["client_id"], appKey);
        expect(params["ios_bundle_id"], "sample_origin");
      };
    });
  });

  test(
      "/oauth/token 400 with wrong enum value and missing description should have both fields as null",
      () async {
    String body = jsonEncode({"error": "invalid_credentials"});
    adapter.setResponseString(body, 401);
    try {
      await authApi.issueAccessToken(
          authCode: "authCode",
          redirectUri: "kakaosample_app_key://oauth",
          appKey: "sample_app_key");
      fail("Should not reach here");
    } on KakaoAuthException catch (e) {
      expect(e.error, AuthErrorCause.unknown);
    } catch (e) {
      expect(e, isInstanceOf<KakaoAuthException>());
    }
  });

  group("/oauth/token refresh access token and refresh token", () {
    var refreshToken = "iMpaTTZe8sAQWpgBDWPGcvN1_tJR24QVcdAcHgopdtYAAAFi_FnbLA";
    var redirectUri = "kakaosample_app_key://oauth";
    var clientId = "sample_app_key";
    OAuthToken? newToken;

    setUp(() async {
      final path = uriPathToFilePath(Constants.tokenPath);
      String body = await loadJson("auth/$path/has_rt.json");
      adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      // setting oldToken
      final path = uriPathToFilePath(Constants.tokenPath);
      var tokenJson = await loadJson("auth/$path/has_rt_and_scopes.json");
      var tokenResponse = AccessTokenResponse.fromJson(jsonDecode(tokenJson));
      await tokenManager.setToken(OAuthToken.fromResponse(tokenResponse));
      final oldToken = await tokenManager.getToken();

      expect(true, oldToken != null);

      newToken = await authApi.refreshToken(
          oldToken: oldToken!, redirectUri: redirectUri, appKey: clientId);

      expect(true, newToken != null);
      expect(true, oldToken.accessToken != newToken!.accessToken);
      expect(true, oldToken.expiresAt != newToken!.expiresAt);
      expect(true, oldToken.refreshToken != newToken!.refreshToken);
      expect(true,
          oldToken.refreshTokenExpiresAt != newToken!.refreshTokenExpiresAt);
      expect(true, listEquals(oldToken.scopes, newToken!.scopes));
    });

    test("on android", () async {
      authApi =
          AuthApi(dio: dio, platform: FakePlatform(operatingSystem: "android"));
      adapter.requestAssertions = (RequestOptions options) {
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
      authApi =
          AuthApi(dio: dio, platform: FakePlatform(operatingSystem: "ios"));
      adapter.requestAssertions = (RequestOptions options) {
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
