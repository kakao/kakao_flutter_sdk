import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';

import '../kakao_flutter_sdk_auth.dart';

/// KO: 토큰 저장소 설정
/// <br>
/// EN: Setting for the token manager
class TokenManagerProvider {
  /// KO: 현재 지정된 토큰 저장소, [TokenManager]를 구현한 사용자 정의 토큰 저장소로 변경 가능(기본값: [DefaultTokenManager])
  /// <br>
  /// EN: Current set token manager, can be changed to a custom [TokenManager] (Default: [DefaultTokenManager])
  TokenManager manager = DefaultTokenManager();

  TokenManagerProvider._();

  /// @nodoc
  static final TokenManagerProvider instance = TokenManagerProvider._();
}

/// KO: 토큰 저장소의 추상 클래스
/// <br>
/// EN: Abstract class of the token manager
abstract class TokenManager {
  /// KO: 리다이렉트 방식 로그인으로 서비스 서버에서 발급받은 토큰을 `TokenManager`에 토큰 할당
  /// <br>
  /// EN: Set tokens in the `TokenManager` that are issued in the service server using Login through redirection
  Future<void> setToken(OAuthToken token);

  /// KO: 저장된 토큰 반환
  /// <br>
  /// EN: Returns saved tokens
  Future<OAuthToken?> getToken();

  /// KO: 저장된 토큰 폐기
  /// <br>
  /// EN: Revokes saved tokens
  Future<void> clear();
}

/// KO: 토큰 저장소
/// <br>
/// EN: Token manager
class DefaultTokenManager implements TokenManager {
  /// @nodoc
  DefaultTokenManager()
    : _preferences = SharedPreferencesAsync(),
      _cipher = AESCipher.create(
        KakaoSdk.platformInfo.origin,
        KakaoSdk.platformInfo.platformId,
      );

  final SharedPreferencesAsync _preferences;
  SharedPreferences? _legacyPreferences;
  final Cipher _cipher;
  OAuthToken? _currentToken;

  @override
  Future<OAuthToken?> getToken() async {
    if (_currentToken != null) {
      return Future.value(_currentToken);
    }

    final version = await _preferences.getString(_versionKey);

    // v1에서는 SharedPreferences에 저장했기 때문에 SharedPreferencesAsync에는 버전 값이 없을 수 있음.
    if (version == null) {
      _legacyPreferences ??= await SharedPreferences.getInstance();
      final legacyVersion = _legacyPreferences?.getString(_versionKey);

      if (legacyVersion != null && isV1Sdk(legacyVersion)) {
        await _migrateV1Token();
      }
    }

    final encryptedToken = await _preferences.getString(_tokenKey);

    if (encryptedToken == null) {
      return null;
    }

    try {
      final jsonToken = _cipher.decrypt(encryptedToken);

      _currentToken = OAuthToken.fromJson(jsonDecode(jsonToken));
    } catch (e) {
      await clear();
      SdkLog.e(
        '[DefaultTokenManager.getToken] decrypt_failed | action=cleared_saved_token',
      );
    }

    return _currentToken;
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    _currentToken = token;
    await _persistToken(token);
    SdkLog.i(
      '[DefaultTokenManager.setToken] completed | hasRefreshToken=${token.refreshToken != null} expiresAt=${token.expiresAt.toIso8601String()}',
    );
  }

  @override
  Future<void> clear() async {
    _currentToken = null;
    await _preferences.remove(_tokenKey);
    SdkLog.i('[DefaultTokenManager.clear] completed');
  }

  bool isV1Sdk(String version) {
    // 1.x.x or 1.x.x+x
    final regExp = RegExp(r'^1\.\d+\.\d+');
    return regExp.hasMatch(version);
  }

  Future<void> _migrateV1Token() async {
    SdkLog.d('[DefaultTokenManager.migrateV1Token] started');

    // https://pub.dev/packages/shared_preferences#migration-and-prefixes
    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
      legacySharedPreferencesInstance: _legacyPreferences!,
      sharedPreferencesAsyncOptions: const SharedPreferencesOptions(),
      migrationCompletedKey: _migrationCompletedKey,
    );

    await _preferences.setString(_versionKey, KakaoSdk.sdkVersion);

    SdkLog.i('[DefaultTokenManager.migrateV1Token] completed');
  }

  Future<void> _persistToken(OAuthToken token) async {
    final jsonToken = jsonEncode(token);
    final encryptedToken = _cipher.encrypt(jsonToken);

    await _preferences.setString(_versionKey, KakaoSdk.sdkVersion);
    await _preferences.setString(_tokenKey, encryptedToken);
  }

  static const _tokenKey = 'com.kakao.token.OAuthToken';
  static const _versionKey = 'com.kakao.token.version';
  static const _migrationCompletedKey =
      'com.kakao.sdk.flutter.v2.migration.completed';
}
