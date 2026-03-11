import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';
import 'support/doubles/fake_auth_platform.dart';
import 'support/doubles/fake_token_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthApi', () {
    late FakeTokenManager fakeTokenManager;
    late FakeAuthPlatform fakeAuthPlatform;

    setUp(() async {
      await KakaoSdk.init(
        nativeAppKey: 'test_app_key',
        platformProvider: FakeCommonPlatform(),
      );

      fakeTokenManager = FakeTokenManager();
      fakeAuthPlatform = FakeAuthPlatform();
    });

    test('should have AuthApi type', () {
      expect(AuthApi, isNotNull);
    });

    group('hasToken', () {
      test('should return true when token exists', () async {
        // Given
        final token = OAuthToken(
          'access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(token);

        final authApi = AuthApi(
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        // When
        final hasToken = await authApi.hasToken();

        // Then
        expect(hasToken, true);
      });

      test('should return false when token does not exist', () async {
        // Given
        final authApi = AuthApi(
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        // When
        final hasToken = await authApi.hasToken();

        // Then
        expect(hasToken, false);
      });

      test('should return false after token is cleared', () async {
        // Given
        final token = OAuthToken(
          'access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(token);

        final authApi = AuthApi(
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        // When
        await fakeTokenManager.clear();
        final hasToken = await authApi.hasToken();

        // Then
        expect(hasToken, false);
      });

      test('Even if the token expires, hasToken can still be true.', () async {
        // Given
        final expiredToken = OAuthToken(
          'expired_access_token',
          DateTime.now().subtract(const Duration(hours: 1)),
          'refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );
        await fakeTokenManager.setToken(expiredToken);

        final authApi = AuthApi(
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        // When
        final hasToken = await authApi.hasToken();
        final token = await fakeTokenManager.getToken();

        // Then - 만료 여부와 관계없이 토큰이 있으면 true
        expect(hasToken, true);
        expect(token!.expiresAt.isBefore(DateTime.now()), true);
      });
    });

    group('Token lifecycle', () {
      test('should set and get token correctly', () async {
        // Given
        final token1 = OAuthToken(
          'token1',
          DateTime.now().add(const Duration(hours: 1)),
          'refresh1',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );

        // When
        await fakeTokenManager.setToken(token1);
        final retrieved1 = await fakeTokenManager.getToken();

        // Then
        expect(retrieved1, isNotNull);
        expect(retrieved1!.accessToken, 'token1');
      });
    });

    group('OAuth flow scenarios', () {
      test(
        'issueAccessToken sends auth code payload and parses token',
        () async {
          final client = TestKakaoHttpClient();
          client.enqueueJson({
            'access_token': 'new_access_token',
            'token_type': 'bearer',
            'expires_in': 3600,
            'refresh_token': 'new_refresh_token',
            'refresh_token_expires_in': 1209600,
            'scope': 'profile friends',
          });

          final authApi = AuthApi(
            client: client,
            tokenManager: fakeTokenManager,
            platform: fakeAuthPlatform,
          );

          final token = await authApi.issueAccessToken(
            authCode: 'auth_code_123',
            redirectUri: 'kakao123://oauth',
            codeVerifier: 'verifier_123',
          );

          final data = client.lastRequest.data as Map<String, dynamic>;
          expect(client.lastRequest.path, Constants.tokenPath);
          expect(data[Constants.code], 'auth_code_123');
          expect(data[Constants.grantType], Constants.authorizationCode);
          expect(data[Constants.clientId], KakaoSdk.appKey);
          expect(data[Constants.redirectUri], 'kakao123://oauth');
          expect(data[Constants.codeVerifier], 'verifier_123');
          expect(token.accessToken, 'new_access_token');
          expect(token.refreshToken, 'new_refresh_token');
          expect(token.scopes, ['profile', 'friends']);
        },
      );

      test(
        'refreshToken uses old token refreshToken when response omits it',
        () async {
          final oldToken = OAuthToken(
            'old_access_token',
            DateTime.now().subtract(const Duration(hours: 1)),
            'old_refresh_token',
            DateTime.now().add(const Duration(days: 30)),
            ['profile'],
          );
          final client = TestKakaoHttpClient();
          client.enqueueJson({
            'access_token': 'refreshed_access_token',
            'token_type': 'bearer',
            'expires_in': 3600,
          });
          final authApi = AuthApi(
            client: client,
            tokenManager: fakeTokenManager,
            platform: fakeAuthPlatform,
          );

          final token = await authApi.refreshToken(oldToken: oldToken);

          final data = client.lastRequest.data as Map<String, dynamic>;
          expect(data[Constants.refreshToken], 'old_refresh_token');
          expect(data[Constants.grantType], Constants.refreshToken);
          expect(token.accessToken, 'refreshed_access_token');
          expect(token.refreshToken, 'old_refresh_token');
        },
      );

      test('refreshToken throws when refresh token does not exist', () async {
        final authApi = AuthApi(
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        await expectLater(
          authApi.refreshToken(),
          throwsA(
            isA<KakaoClientException>().having(
              (e) => e.reason,
              'reason',
              ClientErrorCause.tokenNotFound,
            ),
          ),
        );
      });

      test('agt sends access token and returns agt string', () async {
        await fakeTokenManager.setToken(
          OAuthToken(
            'access_token',
            DateTime.now().add(const Duration(hours: 1)),
            'refresh_token',
            DateTime.now().add(const Duration(days: 30)),
            ['profile'],
          ),
        );
        final client = TestKakaoHttpClient();
        client.enqueueJson({'agt': 'agt_123'});
        final authApi = AuthApi(
          client: client,
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        final agt = await authApi.agt();

        expect(client.lastRequest.path, Constants.agtPath);
        expect(client.lastRequest.data, {
          Constants.clientId: KakaoSdk.appKey,
          Constants.accessToken: 'access_token',
        });
        expect(agt, 'agt_123');
      });

      test('agt throws when there is no access token', () async {
        final authApi = AuthApi(
          tokenManager: fakeTokenManager,
          platform: fakeAuthPlatform,
        );

        await expectLater(
          authApi.agt(),
          throwsA(
            isA<KakaoClientException>().having(
              (e) => e.reason,
              'reason',
              ClientErrorCause.tokenNotFound,
            ),
          ),
        );
      });

      test(
        'codeForWeb returns code or error marker based on response',
        () async {
          final client = TestKakaoHttpClient();
          client.enqueueJson({'code': 'web_code_123'});
          client.enqueueJson({'error': 'invalid_request'});
          final authApi = AuthApi(
            client: client,
            tokenManager: fakeTokenManager,
            platform: fakeAuthPlatform,
          );

          final code = await authApi.codeForWeb('state_1');
          final errorCode = await authApi.codeForWeb('state_2');

          expect(code, 'web_code_123');
          expect(errorCode, Constants.error);
        },
      );
    });
  });
}
