import 'dart:convert';

import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Token storage provider used by kakao flutter sdk
///
/// [DefaultTokenManager] is used as the default storage.
/// If you want to manage tokens yourself, you can set up your own storage by implementing the [TokenManager].
/// If you change the implementation of the storage during the app service, you should consider migrating existing stored tokens for app update users.
///
/// ```dart
/// // Set up custom storage
/// TokenManagerProvider.instance.manager = MyTokenManager();
/// ```
///
class TokenManagerProvider {
  TokenManager manager = DefaultTokenManager();

  /// singleton instance of the default [TokenManagerProvider] used by the SDK.
  static final instance = TokenManagerProvider();
}

/// Stores access token and refresh token from [AuthApi].
///
/// This abstract class can be used to store token information in different locations than provided by the SDK.
abstract class TokenManager {
  /// stores access token and other retrieved information from [AuthApi.issueAccessToken]
  Future<void> setToken(OAuthToken token);

  /// retrieves access token and other information from the designated store.
  Future<OAuthToken?> getToken();

  /// clears all data related to access token from the device.
  Future<void> clear();
}

/// Default [TokenManager] provided by Kakao Flutter SDK.
///
/// Currently uses SharedPreferences (on Android) and UserDefaults (on iOS).
class DefaultTokenManager implements TokenManager {
  static const tokenKey = "com.kakao.token.OAuthToken";
  static const atKey = "com.kakao.token.AccessToken";
  static const atExpiresAtKey = "com.kakao.token.AccessToken.ExpiresAt";
  static const rtKey = "com.kakao.token.RefreshToken";
  static const rtExpiresAtKey = "com.kakao.token.RefreshToken.ExpiresAt";
  static const secureModeKey = "com.kakao.token.KakaoSecureMode";
  static const scopesKey = "com.kakao.token.Scopes";

  static final _instance = DefaultTokenManager._();

  DefaultTokenManager._();

  factory DefaultTokenManager() {
    return _instance;
  }

  /// Deletes all token information.
  @override
  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(tokenKey);
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(tokenKey, jsonEncode(token));
  }

  @override
  Future<OAuthToken?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var jsonToken = preferences.getString(tokenKey);

    if (jsonToken == null) {
      return await _migrateOldToken();
    }
    return OAuthToken.fromJson(jsonDecode(jsonToken));
  }

  // Token management logic has been changed from 0.9.0 version.
  // This code has been added for compatibility with previous versions.
  Future<OAuthToken?> _migrateOldToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString(atKey);
    var refreshToken = preferences.getString(rtKey);
    var atExpiresAtMillis = preferences.getInt(atExpiresAtKey);
    var rtExpiresAtMillis = preferences.getInt(rtExpiresAtKey);
    List<String>? scopes = preferences.getStringList(scopesKey);

    // If token that issued before 0.9.0 version are loaded, then return OAuthToken.
    if (accessToken != null &&
        refreshToken != null &&
        atExpiresAtMillis != null &&
        rtExpiresAtMillis != null) {
      print("=== Migrate from old version token ===");

      var accessTokenExpiresAt =
          DateTime.fromMillisecondsSinceEpoch(atExpiresAtMillis);
      var refreshTokenExpiresAt =
          DateTime.fromMillisecondsSinceEpoch(rtExpiresAtMillis);

      final token = OAuthToken(accessToken, accessTokenExpiresAt, refreshToken,
          refreshTokenExpiresAt, scopes);

      // Remove all token properties that saved before 0.9.0 version and save migrated token.
      await preferences.remove(atKey);
      await preferences.remove(atExpiresAtKey);
      await preferences.remove(rtKey);
      await preferences.remove(rtExpiresAtKey);
      await preferences.remove(secureModeKey);
      await preferences.remove(scopesKey);
      await preferences.setString(tokenKey, jsonEncode(token));
      return token;
    }
    return null;
  }
}
