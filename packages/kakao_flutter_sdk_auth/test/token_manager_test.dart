import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import 'support/doubles/fake_token_manager.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/shared_preferences.dart';

const _tokenKey = 'com.kakao.token.OAuthToken';
const _versionKey = 'com.kakao.token.version';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences legacyPreferences;
  late SharedPreferencesAsync preferences;

  setUp(() async {
    (legacyPreferences, preferences) = await initializeSharedPreferences();

    await KakaoSdk.init(
      nativeAppKey: 'test_app_key',
      platformProvider: FakeCommonPlatform(),
    );
  });

  group('TokenManagerProvider', () {
    test('should be singleton', () {
      final instance1 = TokenManagerProvider.instance;
      final instance2 = TokenManagerProvider.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    test('should have default manager', () {
      expect(TokenManagerProvider.instance.manager, isA<DefaultTokenManager>());
    });

    test('should allow custom manager', () {
      final customManager = FakeTokenManager();
      TokenManagerProvider.instance.manager = customManager;
      expect(TokenManagerProvider.instance.manager, equals(customManager));

      // Reset to default
      TokenManagerProvider.instance.manager = DefaultTokenManager();
    });
  });

  group('DefaultTokenManager', () {
    late Cipher cipher;
    late DefaultTokenManager manager;
    late OAuthToken testToken;

    setUp(() async {
      cipher = AESCipher.create(
        KakaoSdk.platformInfo.origin,
        KakaoSdk.platformInfo.platformId,
      );
      manager = DefaultTokenManager();
      testToken = OAuthToken(
        'test_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        'test_refresh_token',
        DateTime.now().add(const Duration(days: 30)),
        ['profile', 'friends'],
      );
    });

    tearDown(() async {
      await legacyPreferences.clear();
      await preferences.clear();
    });

    test('should return null when no token is saved', () async {
      final token = await manager.getToken();
      expect(token, isNull);
    });

    test('should save and retrieve token', () async {
      await manager.setToken(testToken);
      final retrievedToken = await manager.getToken();

      expect(retrievedToken, isNotNull);
      expect(retrievedToken?.accessToken, equals(testToken.accessToken));
      expect(retrievedToken?.refreshToken, equals(testToken.refreshToken));
    });

    test('should return cached token on second call', () async {
      await manager.setToken(testToken);

      final token1 = await manager.getToken();
      final token2 = await manager.getToken();

      expect(identical(token1, token2), isTrue);
    });

    test('should clear token', () async {
      await manager.setToken(testToken);
      await manager.clear();

      final token = await manager.getToken();
      expect(token, isNull);
    });

    test('should detect v1 SDK version', () {
      expect(manager.isV1Sdk('1.0.0'), isTrue);
      expect(manager.isV1Sdk('1.9.9'), isTrue);
      expect(manager.isV1Sdk('1.0.0+1'), isTrue);
      expect(manager.isV1Sdk('2.0.0'), isFalse);
      expect(manager.isV1Sdk('0.9.0'), isFalse);
    });

    test('should handle token update', () async {
      await manager.setToken(testToken);

      final newToken = OAuthToken(
        'new_access_token',
        DateTime.now().add(const Duration(hours: 2)),
        'new_refresh_token',
        DateTime.now().add(const Duration(days: 60)),
        ['profile', 'friends', 'email'],
      );

      await manager.setToken(newToken);
      final retrievedToken = await manager.getToken();

      expect(retrievedToken?.accessToken, equals('new_access_token'));
    });

    test(
      'token migration check  (SharedPreferences -> SharedPreferencesAsync)',
      () async {
        // 저장된 토큰 없는지 확인
        expect(await manager.getToken(), isNull);

        // 저장된 키 값 없는지 확인
        expect(await preferences.getString(_versionKey), isNull);
        expect(await preferences.getString(_tokenKey), isNull);

        // v1 토큰 세팅
        final encryptedV1Token = cipher.encrypt(jsonEncode(testToken));

        await legacyPreferences.setString(_tokenKey, encryptedV1Token);
        await legacyPreferences.setString(_versionKey, '1.0.0');

        manager = DefaultTokenManager();
        await manager.getToken(); // 토큰 마이그레이션 진행되어야함

        final newVersion = await preferences.getString(_versionKey);
        final v2Token = await preferences.getString(_tokenKey);

        //
        expect(newVersion, equals(KakaoSdk.sdkVersion));
        expect(v2Token, equals(encryptedV1Token));
      },
    );

    test('should handle decryption error', () async {
      // Manually set invalid encrypted token
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_tokenKey, 'invalid_encrypted_data');
      await preferences.setString(_versionKey, KakaoSdk.sdkVersion);

      manager = DefaultTokenManager();
      final token = await manager.getToken();

      expect(token, isNull);
    });

    test('should persist token with encryption', () async {
      await manager.setToken(testToken);

      final preferencesAsync = SharedPreferencesAsync();
      final encryptedToken = await preferencesAsync.getString(_tokenKey);

      expect(encryptedToken, isNotNull);
      expect(encryptedToken, isNot(contains('test_access_token')));
    });

    test('should save SDK version', () async {
      await manager.setToken(testToken);

      final preferencesAsync = SharedPreferencesAsync();
      final version = await preferencesAsync.getString(_versionKey);
      expect(version, equals(KakaoSdk.sdkVersion));
    });

    test('clear should reset cached token', () async {
      await manager.setToken(testToken);
      expect(await manager.getToken(), isNotNull);

      await manager.clear();
      expect(await manager.getToken(), isNull);
    });
  });
}
