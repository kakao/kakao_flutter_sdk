import 'dart:convert';

import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores access token and refresh token from [AuthApi].
///
/// This abstract class can be used to store token information in different locations than provided by the SDK.
abstract class TokenManager {
  // stores access token and other retrieved information from [AuthApi.issueAccessToken]
  Future<void> setToken(OAuthToken token);

  // retrieves access token and other information from the designated store.
  Future<OAuthToken?> getToken();

  // clears all data related to access token from the device.
  Future<void> clear();

  // singleton instance of the default [TokenManager] used by the SDK.
  static final TokenManager instance = DefaultTokenManager();
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

  /// Deletes all token information.
  @override
  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(atKey);
    await preferences.remove(atExpiresAtKey);
    await preferences.remove(rtKey);
    await preferences.remove(rtExpiresAtKey);
    await preferences.remove(secureModeKey);
    await preferences.remove(scopesKey);
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
      return null;
    }
    return OAuthToken.fromJson(jsonDecode(jsonToken));
  }
}
