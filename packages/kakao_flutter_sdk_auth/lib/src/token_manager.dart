import 'dart:convert';

import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// KO: 토큰 저장소 설정
/// <br>
/// EN: Setting for the token manager
class TokenManagerProvider {
  /// KO: 현재 지정된 토큰 저장소, [TokenManager]를 구현한 사용자 정의 토큰 저장소로 변경 가능(기본값: [DefaultTokenManager])
  /// <br>
  /// EN: Current set token manager, can be changed to a custom [TokenManager] (Default: [DefaultTokenManager])
  TokenManager manager = DefaultTokenManager();

  TokenManagerProvider._();

  static final instance = TokenManagerProvider._();
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
  static const tokenKey = "com.kakao.token.OAuthToken";

  /// @nodoc
  static const atKey = "com.kakao.token.AccessToken";

  /// @nodoc
  static const expiresAtKey = "com.kakao.token.AccessToken.ExpiresAt";

  /// @nodoc
  static const rtKey = "com.kakao.token.RefreshToken";

  /// @nodoc
  static const rtExpiresAtKey = "com.kakao.token.RefreshToken.ExpiresAt";

  /// @nodoc
  static const secureModeKey = "com.kakao.token.KakaoSecureMode";

  /// @nodoc
  static const scopesKey = "com.kakao.token.Scopes";

  /// @nodoc
  static const versionKey = "com.kakao.token.version";

  static final _instance = DefaultTokenManager._();

  Cipher? _encryptor;
  SharedPreferences? _preferences;

  OAuthToken? _currentToken;

  DefaultTokenManager._();

  /// @nodoc
  factory DefaultTokenManager() {
    return _instance;
  }

  @override
  Future<void> clear() async {
    _currentToken = null;
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.remove(tokenKey);
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    _encryptor ??= await AESCipher.create();
    _preferences ??= await SharedPreferences.getInstance();
    _preferences!.setString(versionKey, KakaoSdk.sdkVersion);
    await _preferences!
        .setString(tokenKey, _encryptor!.encrypt(jsonEncode(token)));
    _currentToken = token;
  }

  @override
  Future<OAuthToken?> getToken() async {
    if (_currentToken != null) {
      return _currentToken;
    }

    _encryptor ??= await AESCipher.create();
    _preferences ??= await SharedPreferences.getInstance();
    var version = _preferences!.getString(versionKey);
    var jsonToken = _preferences!.getString(tokenKey);

    if (jsonToken == null || version == null) {
      _currentToken = await _migrateOldToken();
    } else {
      try {
        _currentToken =
            OAuthToken.fromJson(jsonDecode(_encryptor!.decrypt(jsonToken)));
      } catch (e) {
        await clear();
        SdkLog.e(
            'A previously saved token was deleted due to an error during decryption. Please login again.');
      }
    }
    return _currentToken;
  }

  // Token management logic has been changed from 0.9.0 version.
  // This code has been added for compatibility with previous versions.
  Future<OAuthToken?> _migrateOldToken() async {
    _preferences ??= await SharedPreferences.getInstance();
    var accessToken = _preferences!.getString(atKey);
    var refreshToken = _preferences!.getString(rtKey);
    var expiresAtMillis = _preferences!.getInt(expiresAtKey);
    var rtExpiresAtMillis = _preferences!.getInt(rtExpiresAtKey);
    List<String>? scopes = _preferences!.getStringList(scopesKey);

    // If token that issued before 0.9.0 version are loaded, then return OAuthToken.
    if (accessToken != null &&
        refreshToken != null &&
        expiresAtMillis != null &&
        rtExpiresAtMillis != null) {
      SdkLog.i("=== Migrate from old version token ===");

      var expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtMillis);
      var refreshTokenExpiresAt =
          DateTime.fromMillisecondsSinceEpoch(rtExpiresAtMillis);

      final token = OAuthToken(
          accessToken, expiresAt, refreshToken, refreshTokenExpiresAt, scopes);

      // Remove all token properties that saved before 0.9.0 version and save migrated token.
      await _preferences!.remove(atKey);
      await _preferences!.remove(expiresAtKey);
      await _preferences!.remove(rtKey);
      await _preferences!.remove(rtExpiresAtKey);
      await _preferences!.remove(secureModeKey);
      await _preferences!.remove(scopesKey);
      await _preferences!
          .setString(tokenKey, _encryptor!.encrypt(jsonEncode(token)));
      await _preferences!.setString(versionKey, KakaoSdk.sdkVersion);
      return token;
    }

    // if a token is issued between version 0.9.0 and version 1.0.0, save the versionKey and encrypt previous token
    var jsonToken = _preferences!.getString(tokenKey);
    if (jsonToken != null) {
      await _preferences!.setString(versionKey, KakaoSdk.sdkVersion);
      await _preferences!.setString(tokenKey, _encryptor!.encrypt(jsonToken));
      return OAuthToken.fromJson(jsonDecode(jsonToken));
    }
    return null;
  }
}
