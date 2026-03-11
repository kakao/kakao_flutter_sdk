import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/user_api.dart';
import 'package:kakao_flutter_sdk_user/src/user_platform.dart';

import '../../kakao_flutter_sdk_auth/test/support/doubles/fake_auth_platform.dart';
import '../../kakao_flutter_sdk_auth/test/support/doubles/fake_token_manager.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/shared_preferences.dart';
import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestKakaoHttpClient client;
  late UserApi api;

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: 'test_app_key',
      platformProvider: FakeCommonPlatform(),
    );
    await initializeSharedPreferences();
    await TokenManagerProvider.instance.manager.clear();

    client = TestKakaoHttpClient();
    api = UserApi(client: client, userPlatform: _FakeUserPlatform());
  });

  test(
    'loginWithKakaoTalk stores issued token and forwards optional params',
    () async {
      final fakeAuthCodeClient = _FakeAuthCodeClient();
      final fakeAuthApi = _FakeAuthApi();
      final authPlatform = FakeAuthPlatform();
      final expectedToken = OAuthToken(
        'talk_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'refresh_token',
        DateTime.now().add(const Duration(days: 30)),
        ['profile'],
      );
      fakeAuthApi.nextToken = expectedToken;

      final talkLoginApi = UserApi(
        client: client,
        authPlatform: authPlatform,
        authCodeClient: fakeAuthCodeClient,
        authApi: fakeAuthApi,
        userPlatform: _FakeUserPlatform(),
      );

      final token = await talkLoginApi.loginWithKakaoTalk(
        channelPublicIds: ['_channel1'],
        serviceTerms: ['terms_1'],
        nonce: 'nonce_value',
      );

      expect(token.accessToken, expectedToken.accessToken);
      expect(fakeAuthCodeClient.lastTalkChannelPublicIds, ['_channel1']);
      expect(fakeAuthCodeClient.lastTalkServiceTerms, ['terms_1']);
      expect(fakeAuthCodeClient.lastTalkNonce, 'nonce_value');
      expect(fakeAuthApi.lastIssueAuthCode, 'talk_auth_code');

      final saved = await TokenManagerProvider.instance.manager.getToken();
      expect(saved?.accessToken, 'talk_access_token');
    },
  );

  test(
    'loginWithKakaoAccount stores token and forwards account options',
    () async {
      final fakeAuthCodeClient = _FakeAuthCodeClient();
      final fakeAuthApi = _FakeAuthApi();
      final authPlatform = FakeAuthPlatform();
      final expectedToken = OAuthToken(
        'account_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'refresh_token',
        DateTime.now().add(const Duration(days: 30)),
        ['profile'],
      );
      fakeAuthApi.nextToken = expectedToken;

      final accountLoginApi = UserApi(
        client: client,
        authPlatform: authPlatform,
        authCodeClient: fakeAuthCodeClient,
        authApi: fakeAuthApi,
        userPlatform: _FakeUserPlatform(),
      );

      await accountLoginApi.loginWithKakaoAccount(
        prompts: [Prompt.login],
        channelPublicIds: ['_channel2'],
        serviceTerms: ['terms_2'],
        loginHint: 'user@kakao.com',
        nonce: 'nonce_2',
      );

      expect(fakeAuthCodeClient.lastAccountPrompts, [Prompt.login]);
      expect(fakeAuthCodeClient.lastAccountChannelPublicIds, ['_channel2']);
      expect(fakeAuthCodeClient.lastAccountServiceTerms, ['terms_2']);
      expect(fakeAuthCodeClient.lastAccountLoginHint, 'user@kakao.com');
      expect(fakeAuthCodeClient.lastAccountNonce, 'nonce_2');

      final saved = await TokenManagerProvider.instance.manager.getToken();
      expect(saved?.accessToken, 'account_access_token');
    },
  );

  test(
    'loginWithNewScopes requests consent and stores refreshed token',
    () async {
      final fakeAuthCodeClient = _FakeAuthCodeClient();
      final fakeAuthApi = _FakeAuthApi();
      final authPlatform = FakeAuthPlatform();
      final expectedToken = OAuthToken(
        'new_scope_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'refresh_token',
        DateTime.now().add(const Duration(days: 30)),
        ['friends'],
      );
      fakeAuthApi.nextToken = expectedToken;

      final scopeLoginApi = UserApi(
        client: client,
        authPlatform: authPlatform,
        authCodeClient: fakeAuthCodeClient,
        authApi: fakeAuthApi,
        userPlatform: _FakeUserPlatform(),
      );

      await scopeLoginApi.loginWithNewScopes(['friends'], nonce: 'scope_nonce');

      expect(fakeAuthCodeClient.lastNewScopes, ['friends']);
      expect(fakeAuthCodeClient.lastNewScopesNonce, 'scope_nonce');

      final saved = await TokenManagerProvider.instance.manager.getToken();
      expect(saved?.accessToken, 'new_scope_access_token');
    },
  );

  test('me sends properties and secureResource query params', () async {
    client.enqueueJson({
      'id': 1,
      'connected_at': '2025-01-01T00:00:00Z',
      'kakao_account': {
        'profile': {'nickname': 'tester'},
      },
    });

    await api.me(properties: ['kakao_account.profile'], secureResource: false);

    final request = client.lastRequest;
    expect(request.path, Constants.v2MePath);
    expect(
      request.queryParameters?[Constants.propertyKeys],
      '["kakao_account.profile"]',
    );
    expect(request.queryParameters?[Constants.secureResource], 'false');
  });

  test('shippingAddresses sends pagination filters', () async {
    client.enqueueJson({
      'user_id': 1,
      'shipping_addresses_needs_agreement': false,
      'shipping_addresses': [],
    });
    final fromUpdatedAt = DateTime.fromMillisecondsSinceEpoch(1710000000000);

    await api.shippingAddresses(
      addressId: 10,
      fromUpdatedAt: fromUpdatedAt,
      pageSize: 20,
    );

    final request = client.lastRequest;
    expect(request.path, Constants.v1ShippingAddressesPath);
    expect(request.queryParameters?[Constants.addressId], 10);
    expect(
      request.queryParameters?[Constants.fromUpdatedAt],
      fromUpdatedAt.millisecondsSinceEpoch / 1000,
    );
    expect(request.queryParameters?[Constants.pageSize], 20);
  });

  test('serviceTerms sends tags and result filters', () async {
    client.enqueueJson({'id': 1, 'service_terms': []});

    await api.serviceTerms(tags: ['tag1', 'tag2'], result: 'app_service_terms');

    final request = client.lastRequest;
    expect(request.path, Constants.v2ServiceTermsPath);
    expect(request.queryParameters?[Constants.tags], 'tag1,tag2');
    expect(request.queryParameters?[Constants.result], 'app_service_terms');
  });

  test('revokeServiceTerms sends comma-separated tags', () async {
    client.enqueueJson({'id': 1, 'revoked_service_terms': []});

    await api.revokeServiceTerms(['tag1', 'tag2']);

    final request = client.lastRequest;
    expect(request.path, Constants.v2RevokeServiceTermsPath);
    expect(request.data, {Constants.tags: 'tag1,tag2'});
  });

  test('updateProfile encodes properties payload', () async {
    client.enqueueJson({});

    await api.updateProfile({'nickname': 'tester'});

    final request = client.lastRequest;
    expect(request.path, Constants.v1UpdateProfilePath);
    expect(request.data, {
      Constants.properties: jsonEncode({'nickname': 'tester'}),
    });
  });

  test('signup sends optional properties only when provided', () async {
    client.enqueueJson({});
    await api.signup(properties: {'nickname': 'tester'});
    expect(client.lastRequest.data, {
      Constants.properties: jsonEncode({'nickname': 'tester'}),
    });

    client.enqueueJson({});
    await api.signup();
    expect(client.lastRequest.data, isNull);
  });

  test('scopes and revokeScopes serialize list values correctly', () async {
    client.enqueueJson({'id': 1, 'scopes': []});
    await api.scopes(scopes: ['friends', 'profile']);
    expect(
      client.lastRequest.queryParameters?[Constants.scopes],
      '["friends","profile"]',
    );

    client.enqueueJson({'id': 1, 'scopes': []});
    await api.revokeScopes(['friends']);
    expect(client.lastRequest.data, {Constants.scopes: '["friends"]'});
  });

  test('logout clears local token even when server request fails', () async {
    final failingClient = TestKakaoHttpClient(
      handler: (_) => throw StateError('network_error'),
    );
    final logoutApi = UserApi(
      client: failingClient,
      userPlatform: _FakeUserPlatform(),
    );
    await TokenManagerProvider.instance.manager.setToken(
      OAuthToken(
        'access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'refresh_token',
        DateTime.now().add(const Duration(days: 30)),
        ['profile'],
      ),
    );

    await expectLater(logoutApi.logout(), throwsA(isA<StateError>()));
    final token = await TokenManagerProvider.instance.manager.getToken();
    expect(token, isNull);
  });
}

class _FakeUserPlatform implements UserPlatform {
  @override
  Future<int> selectShippingAddress({
    bool? mobileView,
    bool? enableBackButton,
  }) async => 1;
}

class _FakeAuthCodeClient extends AuthCodeClient {
  _FakeAuthCodeClient() : super(api: AuthApi(), platform: FakeAuthPlatform());

  String? lastTalkNonce;
  List<String>? lastTalkChannelPublicIds;
  List<String>? lastTalkServiceTerms;

  List<Prompt>? lastAccountPrompts;
  String? lastAccountLoginHint;
  String? lastAccountNonce;
  List<String>? lastAccountChannelPublicIds;
  List<String>? lastAccountServiceTerms;

  List<String>? lastNewScopes;
  String? lastNewScopesNonce;

  @override
  Future<String> authorizeWithTalk({
    required String redirectUri,
    String? nonce,
    List<String>? channelPublicId,
    List<String>? serviceTerms,
    String? stateToken,
    String? codeVerifier,
  }) async {
    lastTalkNonce = nonce;
    lastTalkChannelPublicIds = channelPublicId;
    lastTalkServiceTerms = serviceTerms;
    return 'talk_auth_code';
  }

  @override
  Future<String> authorize({
    required String redirectUri,
    List<Prompt>? prompts,
    String? loginHint,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? codeVerifier,
  }) async {
    lastAccountPrompts = prompts;
    lastAccountLoginHint = loginHint;
    lastAccountNonce = nonce;
    lastAccountChannelPublicIds = channelPublicIds;
    lastAccountServiceTerms = serviceTerms;
    return 'account_auth_code';
  }

  @override
  Future<String> authorizeWithNewScopes({
    required String redirectUri,
    required List<String> scopes,
    String? nonce,
    String? codeVerifier,
  }) async {
    lastNewScopes = scopes;
    lastNewScopesNonce = nonce;
    return 'new_scope_auth_code';
  }
}

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi()
    : super(
        client: TestKakaoHttpClient(),
        tokenManager: FakeTokenManager(),
        platform: FakeAuthPlatform(),
      );

  OAuthToken? nextToken;
  String? lastIssueAuthCode;

  @override
  Future<OAuthToken> issueAccessToken({
    required String authCode,
    required String redirectUri,
    required String codeVerifier,
  }) async {
    lastIssueAuthCode = authCode;
    return nextToken ??
        OAuthToken(
          'default_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'refresh_token',
          DateTime.now().add(const Duration(days: 30)),
          ['profile'],
        );
  }
}
