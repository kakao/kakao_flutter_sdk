import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';
import 'test_double.dart';

void main() {
  late Dio dio;
  late MockAdapter adapter;
  late MockAdapter authAdapter;
  late MockAdapter interceptorDioAdapter;
  late AuthApi authApi;
  late TokenManager tokenManager;
  late AccessTokenInterceptor interceptor;

  TestWidgetsFlutterBinding.ensureInitialized();

  var appKey = "sample_app_key";
  KakaoSdk.init(nativeAppKey: appKey);

  registerMockMethodChannel();
  registerMockSharedPreferencesMethodChannel();

  setUp(() {
    DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 12);
    DateTime refreshTokenExpiresAt = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 24 * 30 * 2);

    tokenManager = TestTokenManager(testOAuthToken(
        expiresAt: expiresAt, refreshTokenExpiresAt: refreshTokenExpiresAt));
    TokenManagerProvider.instance.manager = tokenManager;

    adapter = MockAdapter();
    dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(ApiFactory.kaInterceptor)
      ..options.baseUrl = "https://${KakaoSdk.hosts.kapi}";

    authAdapter = MockAdapter();
    var kauthDio = Dio()
      ..httpClientAdapter = authAdapter
      ..interceptors.add(ApiFactory.kaInterceptor)
      ..options.baseUrl = "https://${KakaoSdk.hosts.kauth}";
    authApi = AuthApi(dio: kauthDio);

    interceptorDioAdapter = MockAdapter();
    interceptor = AccessTokenInterceptor(
      Dio()
        ..httpClientAdapter = interceptorDioAdapter
        ..interceptors.add(ApiFactory.kaInterceptor)
        ..options.baseUrl = "https://${KakaoSdk.hosts.kapi}",
      authApi,
    );
    dio.interceptors.add(interceptor);
  });

  group('AccessTokenInterceptorTest', () {
    test('authorization', () async {
      adapter.setResponseString('', 200);

      Response response = await dio.get('/');
      OAuthToken? token = await tokenManager.getToken();

      expect(response.requestOptions.headers['Authorization'],
          "Bearer ${token?.accessToken}");
    });

    test('refresh - only access_token', () async {
      String accessToken = 'access_token';

      // before refresh access token
      expect((await tokenManager.getToken())?.accessToken, 'test_access_token');
      expect(
          (await tokenManager.getToken())?.refreshToken, 'test_refresh_token');

      var jsonString =
          '{"access_token":"$accessToken", "token_type":"bearer", "expires_in":43199}';
      ResponseBody tokenResponse =
          ResponseBody.fromString(jsonString, 200, headers: {
        HttpHeaders.contentTypeHeader: [ContentType.json.mimeType]
      });
      authAdapter.setResponse(tokenResponse);
      adapter.setResponseString(
          '{"msg":"this access token does not exist","code":-401}', 401);
      interceptorDioAdapter.setResponseString('', 200);

      await dio.get('/');

      // after refresh access token
      expect((await tokenManager.getToken())?.accessToken, accessToken);
      expect(
          (await tokenManager.getToken())?.refreshToken, 'test_refresh_token');
    });

    test('refresh - only access_token', () async {
      String accessToken = 'access_token';
      String refreshToken = 'refresh_token';

      // before refresh tokens
      expect((await tokenManager.getToken())?.accessToken, 'test_access_token');
      expect(
          (await tokenManager.getToken())?.refreshToken, 'test_refresh_token');

      var jsonString =
          '{"access_token":"$accessToken","token_type":"bearer","refresh_token":"$refreshToken", "expires_in":43199, "refresh_token_expires_in":2591999}';
      ResponseBody tokenResponse =
          ResponseBody.fromString(jsonString, 200, headers: {
        HttpHeaders.contentTypeHeader: [ContentType.json.mimeType]
      });
      authAdapter.setResponse(tokenResponse);
      adapter.setResponseString(
          '{"msg":"this access token does not exist","code":-401}', 401);
      interceptorDioAdapter.setResponseString('', 200);

      await dio.get('/');

      // after refresh tokens
      expect((await tokenManager.getToken())?.accessToken, accessToken);
      expect((await tokenManager.getToken())?.refreshToken, refreshToken);
    });
  });
}
