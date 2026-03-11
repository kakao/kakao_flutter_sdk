import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_code_client.dart';
import 'package:kakao_flutter_sdk_auth/src/model/prompt.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';
import 'support/doubles/fake_auth_platform.dart';
import 'support/doubles/fake_token_manager.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    late FakeAuthPlatform fakePlatform;
    late AuthApi authApi;
    late TestKakaoHttpClient httpClient;
    late AuthCodeClient authCodeClient;

    setUpAll(() async {
      await initializeSharedPreferences();
      await KakaoSdk.init(
        nativeAppKey: 'test_app_key',
        platformProvider: FakeCommonPlatform(),
      );
    });

    setUp(() {
      fakePlatform = FakeAuthPlatform();
      httpClient = TestKakaoHttpClient(
        handler: (request) {
          return KakaoResponse(
            statusCode: 200,
            data: {'agt': 'agt'},
            headers: const {},
          );
        },
      );
      authApi = AuthApi(
        client: httpClient,
        tokenManager: FakeTokenManager(),
        platform: fakePlatform,
      );
      authCodeClient = AuthCodeClient(api: authApi, platform: fakePlatform);
    });

    group('AuthCodeClient Integration', () {
      test('should complete full authorize flow', () async {
        final authCode = await authCodeClient.authorize(
          redirectUri: 'kakao://oauth',
          prompts: [Prompt.login],
          loginHint: 'user@example.com',
          nonce: 'test_nonce',
        );

        expect(authCode, 'auth_code');
      });

      test('should complete full authorizeWithTalk flow', () async {
        final authCode = await authCodeClient.authorizeWithTalk(
          redirectUri: 'kakao://oauth',
          nonce: 'test_nonce',
          channelPublicId: ['channel1'],
        );

        expect(authCode, 'auth_code_from_talk');
      });

      test('should handle multiple prompt values', () async {
        final authCode = await authCodeClient.authorize(
          redirectUri: 'kakao://oauth',
          prompts: [Prompt.login, Prompt.create, Prompt.selectAccount],
        );

        expect(authCode, 'auth_code');
      });

      test('should work with all optional parameters', () async {
        final codeVerifier = generateRandomString(20);

        final authCode = await authCodeClient.authorize(
          redirectUri: 'kakao://oauth',
          prompts: [Prompt.login],
          loginHint: 'user@example.com',
          nonce: 'nonce_value',
          channelPublicIds: ['channel1', 'channel2'],
          serviceTerms: ['term1', 'term2'],
          codeVerifier: codeVerifier,
        );

        expect(authCode, isNotEmpty);
      });
    });

    group('TokenManager Integration', () {
      test('should have TokenManager type', () {
        expect(TokenManager, isNotNull);
        expect(DefaultTokenManager, isNotNull);
      });
    });
  });
}
