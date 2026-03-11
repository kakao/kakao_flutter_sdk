import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_code_client.dart';
import 'package:kakao_flutter_sdk_auth/src/model/prompt.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';
import 'support/doubles/fake_auth_platform.dart';
import 'support/doubles/fake_token_manager.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthCodeClient', () {
    late FakeAuthPlatform fakePlatform;
    late AuthApi authApi;
    late TestKakaoHttpClient httpClient;
    late AuthCodeClient client;

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
      client = AuthCodeClient(api: authApi, platform: fakePlatform);
    });

    test('should have a singleton instance', () {
      expect(AuthCodeClient.instance, isNotNull);
    });

    group('authorizeWithTalk', () {
      test(
        'should call platform authorizeWithTalk with correct parameters',
        () async {
          final result = await client.authorizeWithTalk(
            redirectUri: 'kakao://oauth',
            nonce: 'test_nonce',
            channelPublicId: ['channel1', 'channel2'],
            serviceTerms: ['term1', 'term2'],
          );

          expect(result, 'auth_code_from_talk');
          expect(fakePlatform.lastRedirectUri, 'kakao://oauth');
          expect(fakePlatform.lastNonce, 'test_nonce');
          expect(fakePlatform.lastChannelPublicIds, ['channel1', 'channel2']);
          expect(fakePlatform.lastServiceTerms, ['term1', 'term2']);
        },
      );

      test('should work with minimal parameters', () async {
        final result = await client.authorizeWithTalk(
          redirectUri: 'kakao://oauth',
        );

        expect(result, 'auth_code_from_talk');
        expect(fakePlatform.lastRedirectUri, 'kakao://oauth');
      });

      test('should create PKCE when codeVerifier is provided', () async {
        final result = await client.authorizeWithTalk(
          redirectUri: 'kakao://oauth',
          codeVerifier: 'test_verifier',
        );

        expect(result, 'auth_code_from_talk');
      });
    });

    group('authorize', () {
      test('should call platform authorize with correct parameters', () async {
        final result = await client.authorize(
          redirectUri: 'kakao://oauth',
          prompts: [Prompt.login, Prompt.create],
          loginHint: 'test@example.com',
          nonce: 'test_nonce',
          channelPublicIds: ['channel1'],
          serviceTerms: ['term1'],
        );

        expect(result, 'auth_code');
        expect(fakePlatform.lastRedirectUri, 'kakao://oauth');
        expect(fakePlatform.lastPrompts, [Prompt.login, Prompt.create]);
        expect(fakePlatform.lastLoginHint, 'test@example.com');
        expect(fakePlatform.lastNonce, 'test_nonce');
        expect(fakePlatform.lastChannelPublicIds, ['channel1']);
        expect(fakePlatform.lastServiceTerms, ['term1']);
      });

      test('should work with minimal parameters', () async {
        final result = await client.authorize(redirectUri: 'kakao://oauth');

        expect(result, 'auth_code');
        expect(fakePlatform.lastRedirectUri, 'kakao://oauth');
      });

      test('should create PKCE when codeVerifier is provided', () async {
        final result = await client.authorize(
          redirectUri: 'kakao://oauth',
          codeVerifier: 'test_verifier',
        );

        expect(result, 'auth_code');
      });
    });
  });
}
