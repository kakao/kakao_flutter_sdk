import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_code_client.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/network/required_scopes_interceptor.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../../kakao_flutter_sdk_common/test/shared/doubles/fake_http_client_adapter.dart';
import '../../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';
import '../support/doubles/fake_auth_platform.dart';
import '../support/doubles/fake_token_manager.dart';
import '../support/utils/auth_token_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late FakeTokenManager mockTokenManager;
  late AuthApi authApi;
  late TestKakaoHttpClient authHttpClient;
  late AuthCodeClient authCodeClient;
  int issueAccessTokenCallCount = 0;
  String? lastAuthCode;
  OAuthToken? issueAccessTokenResult;
  Exception? issueAccessTokenException;
  late FakeAuthPlatform mockAuthPlatform;
  late RequiredScopesInterceptor interceptor;

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: 'mock_native_app_key',
      platformProvider: FakeCommonPlatform(),
    );

    // Dio 및 Mock 객체 초기화
    dio = Dio(BaseOptions(baseUrl: 'https://kapi.kakao.com'));
    mockTokenManager = FakeTokenManager();
    mockAuthPlatform = FakeAuthPlatform();
    mockAuthPlatform.authorizeWithNewScopesCallCount = 0;
    mockAuthPlatform.newScopesAuthCode = null;
    mockAuthPlatform.newScopesError = null;
    issueAccessTokenCallCount = 0;
    lastAuthCode = null;
    issueAccessTokenResult = null;
    issueAccessTokenException = null;

    authHttpClient = TestKakaoHttpClient(
      handler: (request) async {
        if (request.path == Constants.agtPath) {
          return KakaoResponse(
            statusCode: 200,
            data: {Constants.agt: 'agt'},
            headers: const {},
          );
        }

        final data = request.data;
        if (data is! Map) {
          throw StateError('Auth request data must be a Map.');
        }
        final grantType = data[Constants.grantType];
        if (grantType == Constants.authorizationCode) {
          issueAccessTokenCallCount++;
          lastAuthCode = data[Constants.code]?.toString();

          if (issueAccessTokenException != null) {
            throw issueAccessTokenException!;
          }
          if (issueAccessTokenResult == null) {
            throw Exception('issueAccessToken result not set');
          }

          await mockTokenManager.setToken(issueAccessTokenResult!);
          return buildTokenResponse(issueAccessTokenResult!);
        }

        throw UnsupportedError('Unsupported grant_type: $grantType');
      },
    );
    authApi = AuthApi(
      client: authHttpClient,
      tokenManager: mockTokenManager,
      platform: mockAuthPlatform,
    );
    authCodeClient = AuthCodeClient(api: authApi, platform: mockAuthPlatform);

    interceptor = RequiredScopesInterceptor(
      dio,
      authCodeClient: authCodeClient,
      authApi: authApi,
      platform: mockAuthPlatform,
      tokenManager: mockTokenManager,
    );

    dio.interceptors.add(interceptor);
  });

  group('RequiredScopesInterceptor - insufficientScope error handling', () {
    test(
      'Verify that token is refreshed and request is retried when insufficientScope error occurs',
      () async {
        // Given: 유효한 토큰 설정
        final oldToken = OAuthToken(
          'old_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await mockTokenManager.setToken(oldToken);

        // 필요한 스코프 설정
        final requiredScopes = ['account_email', 'friends'];

        // Mock 인증 코드 클라이언트 설정
        mockAuthPlatform.newScopesAuthCode = 'new_auth_code';

        // 갱신된 토큰 설정
        final newToken = OAuthToken(
          'new_access_token',
          DateTime.now().add(const Duration(hours: 2)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile', 'account_email', 'friends'],
        );
        issueAccessTokenResult = newToken;

        // Mock 서버 응답 설정
        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        // 첫 번째 요청: -402 에러 (Insufficient Scope)
        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInsufficientScopeError(requiredScopes);

        // 두 번째 요청 (재시도): 성공
        httpClientAdapter.mockRetryResponse = ResponseBody.fromString(
          '{"result": "success", "data": "test_data"}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );

        // When: API 요청 실행
        final response = await dio.get('/v1/user/me');

        // Then:
        // 1. authorizeWithNewScopes가 호출되었는지 확인
        expect(mockAuthPlatform.authorizeWithNewScopesCallCount, 1);
        expect(mockAuthPlatform.lastScopes, requiredScopes);

        // 2. issueAccessToken이 호출되었는지 확인
        expect(issueAccessTokenCallCount, 1);
        expect(lastAuthCode, 'new_auth_code');

        // 3. 재시도 요청의 헤더가 갱신된 토큰으로 설정되었는지 확인
        expect(
          response.requestOptions.headers[Constants.authorization],
          '${Constants.bearer} new_access_token',
        );

        // 4. 최종 응답이 성공인지 확인
        expect(response.statusCode, 200);
        expect(response.data['result'], 'success');

        // 5. 갱신된 토큰이 저장되어 있어야 함
        final currentToken = await mockTokenManager.getToken();
        expect(currentToken?.accessToken, 'new_access_token');
        expect(currentToken?.scopes, ['profile', 'account_email', 'friends']);
      },
      skip: kIsWeb,
    );

    test(
      'Verify that error is passed through when error is not insufficientScope',
      () async {
        // Given
        final token = OAuthToken(
          'test_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await mockTokenManager.setToken(token);

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        // -401 에러 (Invalid Token)
        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInvalidTokenError();

        // When & Then
        expect(
          () => dio.get('/v1/user/me'),
          throwsA(
            isA<DioException>().having(
              (e) => e.response?.statusCode,
              'statusCode',
              401,
            ),
          ),
        );

        // authorizeWithNewScopes가 호출되지 않았는지 확인
        expect(mockAuthPlatform.authorizeWithNewScopesCallCount, 0);
      },
      skip: kIsWeb,
    );

    test(
      'Verify that error is properly handled when user cancels the consent screen',
      () async {
        // Given
        final token = OAuthToken(
          'test_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await mockTokenManager.setToken(token);

        final requiredScopes = ['account_email'];

        // 사용자가 동의 화면에서 취소
        mockAuthPlatform.newScopesError = KakaoAuthException(
          AuthErrorCause.accessDenied,
          'User cancelled',
        );

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInsufficientScopeError(requiredScopes);

        // When & Then
        try {
          await dio.get('/v1/user/me');
          fail('Expected DioException to be thrown');
        } catch (e) {
          expect(e, isA<DioException>());
          expect((e as DioException).error, isA<KakaoAuthException>());
        }

        // authorizeWithNewScopes가 호출되었는지 확인
        expect(mockAuthPlatform.authorizeWithNewScopesCallCount, 1);

        // issueAccessToken은 호출되지 않았는지 확인
        expect(issueAccessTokenCallCount, 0);
      },
      skip: kIsWeb,
    );

    test(
      'Verify that error is properly handled when token issuance fails',
      () async {
        // Given
        final token = OAuthToken(
          'test_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'test_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await mockTokenManager.setToken(token);

        final requiredScopes = ['account_email'];

        mockAuthPlatform.newScopesAuthCode = 'new_auth_code';

        // 토큰 발급 실패 설정
        issueAccessTokenException = DioException(
          requestOptions: RequestOptions(
            baseUrl: 'https://${KakaoSdk.hosts.kauth}',
          ),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 400,
            data: {'msg': 'Invalid authorization code', 'code': -401},
          ),
        );

        final httpClientAdapter = FakeHttpClientAdapter();
        dio.httpClientAdapter = httpClientAdapter;

        httpClientAdapter.mockFirstRequestFails = true;
        httpClientAdapter.mockInsufficientScopeError(requiredScopes);

        // When & Then
        try {
          await dio.get('/v1/user/me');
          fail('Expected DioException to be thrown');
        } catch (e) {
          expect(e, isA<DioException>());
        }

        // authorizeWithNewScopes가 호출되었는지 확인
        expect(mockAuthPlatform.authorizeWithNewScopesCallCount, 1);

        // issueAccessToken이 호출되었는지 확인
        expect(issueAccessTokenCallCount, 1);
      },
      skip: kIsWeb,
    );
  });
}
