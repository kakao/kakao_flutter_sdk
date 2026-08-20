import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/network/access_token_interceptor.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../../kakao_flutter_sdk_common/test/shared/doubles/fake_http_client_adapter.dart';
import '../../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';
import '../support/doubles/fake_token_manager.dart';
import '../support/utils/auth_token_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late FakeTokenManager fakeTokenManager;
  late AuthApi authApi;
  late TestKakaoHttpClient authHttpClient;
  late AccessTokenInterceptor interceptor;
  int refreshTokenCallCount = 0;
  String? lastRefreshToken;
  OAuthToken? refreshTokenResult;
  Exception? refreshTokenException;

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: 'mock_native_app_key',
      platformProvider: FakeCommonPlatform(),
    );

    dio = Dio(BaseOptions(baseUrl: 'https://kapi.kakao.com'));
    fakeTokenManager = FakeTokenManager();
    refreshTokenCallCount = 0;
    lastRefreshToken = null;
    refreshTokenResult = null;
    refreshTokenException = null;

    authHttpClient = TestKakaoHttpClient(
      handler: (request) async {
        final data = request.data;
        if (data is! Map) {
          throw StateError('Auth request data must be a Map.');
        }
        final grantType = data[Constants.grantType];
        if (grantType == Constants.refreshToken) {
          refreshTokenCallCount++;
          lastRefreshToken = data[Constants.refreshToken]?.toString();

          if (refreshTokenException != null) {
            throw refreshTokenException!;
          }
          if (refreshTokenResult == null) {
            throw Exception('refreshToken result not set');
          }

          return buildTokenResponse(refreshTokenResult!);
        }

        throw UnsupportedError('Unsupported grant_type: $grantType');
      },
    );
    authApi = AuthApi(client: authHttpClient, tokenManager: fakeTokenManager);

    interceptor = AccessTokenInterceptor(
      dio,
      authApi: authApi,
      tokenManager: fakeTokenManager,
    );

    dio.interceptors.add(interceptor);
  });

  group('AccessTokenInterceptor - onRequest', () {
    test('Verify accessToken is added to the request header.', () async {
      // Given: 유효한 토큰이 존재
      final token = OAuthToken(
        'test_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'test_refresh_token',
        DateTime.now().add(const Duration(days: 60)),
        ['profile'],
      );
      await fakeTokenManager.setToken(token);

      // Mock 서버 응답 설정
      final httpClientAdapter = FakeHttpClientAdapter();
      dio.httpClientAdapter = httpClientAdapter;
      httpClientAdapter.mockResponse = ResponseBody.fromString(
        '{"result": "success"}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      // When: API 요청 실행
      final response = await dio.get('/v1/user/me');

      // Then: Authorization 헤더가 올바르게 설정되었는지 확인
      expect(
        response.requestOptions.headers[Constants.authorization],
        '${Constants.bearer} test_access_token',
      );
      expect(response.statusCode, 200);
    });

    test('error occurs when no token is present', () async {
      // Given: 토큰이 없음
      await fakeTokenManager.clear();

      // Mock 서버 응답 설정
      final httpClientAdapter = FakeHttpClientAdapter();
      dio.httpClientAdapter = httpClientAdapter;

      // When & Then: DioException 발생 확인
      expect(
        () => dio.get('/v1/user/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.message,
            'message',
            "authentication token doesn't exist.",
          ),
        ),
      );
    });
  });

  group('AccessTokenInterceptor - onError (Token Refresh)', () {
    test(
      'Verify that the token is refreshed and the request is resubmitted when the token expires.',
      () async {
        // Given: 유효한 토큰 설정
        final oldToken = OAuthToken(
          'old_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(oldToken);

        // 갱신된 토큰 설정
        final newToken = OAuthToken(
          'new_access_token',
          DateTime.now().add(const Duration(hours: 2)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        refreshTokenResult = newToken;

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        // 첫 번째 요청: 401 에러 (Invalid Token)
        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInvalidTokenError();

        // 두 번째 요청 (재시도): 성공
        httpClientAdapter.mockResponse = ResponseBody.fromString(
          '{"result": "success"}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );

        // When: API 요청 실행
        final response = await dio.get('/v1/user/me');

        // Then:
        // 1. refreshToken이 호출되었는지 확인
        expect(refreshTokenCallCount, 1);
        expect(lastRefreshToken, oldToken.refreshToken);

        // 2. 재시도 요청의 헤더가 갱신된 토큰으로 설정되었는지 확인
        expect(
          response.requestOptions.headers[Constants.authorization],
          '${Constants.bearer} new_access_token',
        );

        // 3. 최종 응답이 성공인지 확인
        expect(response.statusCode, 200);
      },
      skip: kIsWeb,
    );

    test('Verify token refresh when encountering KAPI 401 error', () async {
      // Given
      final oldToken = OAuthToken(
        'old_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'test_refresh_token',
        DateTime.now().add(const Duration(days: 60)),
        ['profile'],
      );
      await fakeTokenManager.setToken(oldToken);

      final newToken = OAuthToken(
        'new_access_token',
        DateTime.now().add(const Duration(hours: 2)),
        'test_refresh_token',
        DateTime.now().add(const Duration(days: 60)),
        ['profile'],
      );
      refreshTokenResult = newToken;

      final httpClientAdapter = FakeHttpClientAdapter();
      dio.httpClientAdapter = httpClientAdapter;

      // KAPI 401 에러 응답
      httpClientAdapter.mockFirstRequestFails = true;
      httpClientAdapter.mockResponse = ResponseBody.fromString(
        '{"msg":"Invalid access token","code":-401,"reason":"ACCESS_TOKEN_EXPIRED"}',
        401,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      // 재시도 성공
      httpClientAdapter.mockRetryResponse = ResponseBody.fromString(
        '{"result": "success"}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      // When
      final response = await dio.get('/v1/user/me');

      // Then
      expect(refreshTokenCallCount, 1);
      expect(response.statusCode, 200);
    }, skip: kIsWeb);

    test(
      'Verify refresh is attempted only once when retry also fails with invalid token',
      () async {
        final oldToken = OAuthToken(
          'old_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(oldToken);

        final newToken = OAuthToken(
          'new_access_token',
          DateTime.now().add(const Duration(hours: 2)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        refreshTokenResult = newToken;

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInvalidTokenError();
        httpClientAdapter.mockRetryResponse = ResponseBody.fromString(
          '{"msg":"Invalid access token","code":-401,"reason":"ACCESS_TOKEN_EXPIRED"}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );

        await expectLater(dio.get('/v1/user/me'), throwsA(isA<DioException>()));

        // refresh는 정확히 한 번만 수행되어야 한다.
        expect(refreshTokenCallCount, 1);
      },
      skip: kIsWeb,
    );

    test(
      'Confirm token deletion in the token manager when token renewal fails',
      () async {
        // Given
        final oldToken = OAuthToken(
          'old_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(oldToken);

        // refreshToken 실패 설정
        refreshTokenException = DioException(
          requestOptions: RequestOptions(
            baseUrl: 'https://${KakaoSdk.hosts.kauth}',
          ),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: {'msg': 'Invalid refresh token', 'code': -401, 'reason': 'ACCESS_TOKEN_EXPIRED'},
          ),
        );

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInvalidTokenError();

        // When & Then
        try {
          await dio.get('/v1/user/me');
          fail('Exception expected');
        } catch (e) {
          // 토큰이 삭제되었는지 확인
          final token = await fakeTokenManager.getToken();
          expect(token, isNull);
        }
      },
      skip: kIsWeb,
    );
  });

  group('AccessTokenInterceptor - Multiple request', () {
    test('Verify that it can handle multiple requests', () async {
      // Given: 유효한 토큰 설정
      final oldToken = OAuthToken(
        'old_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'test_refresh_token',
        DateTime.now().add(const Duration(days: 60)),
        ['profile'],
      );
      await fakeTokenManager.setToken(oldToken);

      // 갱신된 토큰 설정
      final newToken = OAuthToken(
        'new_access_token',
        DateTime.now().add(const Duration(hours: 2)),
        'test_refresh_token',
        DateTime.now().add(const Duration(days: 60)),
        ['profile'],
      );
      refreshTokenResult = newToken;

      final httpClientAdapter = FakeHttpClientAdapter();
      dio.httpClientAdapter = httpClientAdapter;

      // old_access_token으로 오는 모든 요청은 401 에러, new_access_token으로 오는 요청은 성공
      httpClientAdapter.mockResponseCallback = () {
        final authHeader = httpClientAdapter
            .lastRequestOptions
            ?.headers[Constants.authorization];
        if (authHeader == '${Constants.bearer} old_access_token') {
          throw DioException(
            requestOptions: httpClientAdapter.lastRequestOptions!,
            response: Response(
              requestOptions: httpClientAdapter.lastRequestOptions!,
              statusCode: 401,
              data: {'msg': 'Invalid access token', 'code': -401, 'reason': 'ACCESS_TOKEN_EXPIRED'},
            ),
            type: DioExceptionType.badResponse,
          );
        }
        return ResponseBody.fromString(
          '{"result": "success"}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      // When: 3개의 요청을 동시에 실행
      final futures = <Future<Response>>[];
      for (int i = 0; i < 3; i++) {
        futures.add(dio.get('/v1/user/me'));
      }

      final responses = await Future.wait(futures);

      // Then:
      // 1. refreshToken은 한 번만 호출되어야 함
      expect(refreshTokenCallCount, 1);

      // 2. 모든 요청이 성공해야 함
      for (final response in responses) {
        expect(response.statusCode, 200);
      }

      // 3. 갱신된 토큰이 저장되어 있어야 함
      final currentToken = await fakeTokenManager.getToken();
      expect(currentToken?.accessToken, 'new_access_token');
    }, skip: kIsWeb);

    test(
      'Verify that refreshToken is not called again if another concurrent request has already refreshed the token',
      () async {
        // Given
        final oldToken = OAuthToken(
          'old_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(oldToken);

        final newToken = OAuthToken(
          'new_access_token',
          DateTime.now().add(const Duration(hours: 2)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );

        refreshTokenResult = newToken;

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        // old_access_token으로 오는 모든 요청은 401 에러
        // new_access_token으로 오는 요청은 성공
        httpClientAdapter.mockResponseCallback = () {
          final authHeader = httpClientAdapter
              .lastRequestOptions
              ?.headers[Constants.authorization];
          if (authHeader == '${Constants.bearer} old_access_token') {
            throw DioException(
              requestOptions: httpClientAdapter.lastRequestOptions!,
              response: Response(
                requestOptions: httpClientAdapter.lastRequestOptions!,
                statusCode: 401,
                data: {'msg': 'Invalid access token', 'code': -401, 'reason': 'ACCESS_TOKEN_EXPIRED'},
              ),
              type: DioExceptionType.badResponse,
            );
          }
          return ResponseBody.fromString(
            '{"result": "success"}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        };

        // When: 2개의 요청을 순차적으로 실행 (첫 번째가 처리되는 동안 두 번째 실행)
        final response1Future = dio.get('/v1/user/me');
        await Future.delayed(const Duration(milliseconds: 50));
        final response2Future = dio.get('/v1/user/me');

        final responses = await Future.wait([response1Future, response2Future]);

        // Then:
        // 1. refreshToken은 한 번만 호출되어야 함
        expect(refreshTokenCallCount, 1);

        // 2. 두 번째 요청은 이미 갱신된 토큰으로 바로 재시도
        for (final response in responses) {
          expect(response.statusCode, 200);
        }
      },
      skip: kIsWeb,
    );
  });
}
