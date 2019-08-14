import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores access token and refresh token from [AuthApi].
///
/// This abstract class can be used to store token information in different locations than provided by the SDK.
abstract class AccessTokenStore {
  Future<AccessToken> toStore(AccessTokenResponse response);

  Future<AccessToken> fromStore();

  Future<void> clear();

  static final AccessTokenStore instance = DefaultAccessTokenStore();
}

/// Default [AccessTokenStore] provided by Kakao Flutter SDK.
///
/// Currently uses SharedPreferences (on Android) and UserDefaults (on iOS).
class DefaultAccessTokenStore implements AccessTokenStore {
  static const atKey = "com.kakao.token.AccessToken";
  static const atExpiresAtKey = "com.kakao.token.AccessToken.ExpiresAt";
  static const rtKey = "com.kakao.token.RefreshToken";
  static const rtExpiresAtKey = "com.kakao.token.RefreshToken.ExpiresAt";
  static const secureModeKey = "com.kakao.token.KakaoSecureMode";
  static const scopesKey = "com.kakao.token.Scopes";

  /// Deletes all token information.
  clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(atKey);
    preferences.remove(atExpiresAtKey);
    preferences.remove(rtKey);
    preferences.remove(rtExpiresAtKey);
    preferences.remove(secureModeKey);
    preferences.remove(scopesKey);
  }

  Future<AccessToken> toStore(AccessTokenResponse response) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(atKey, response.accessToken);
    preferences.setInt(atExpiresAtKey,
        DateTime.now().millisecondsSinceEpoch + response.expiresIn * 1000);
    if (response.refreshToken != null) {
      preferences.setString(rtKey, response.refreshToken);
      preferences.setInt(
          rtExpiresAtKey,
          DateTime.now().millisecondsSinceEpoch +
              response.refreshTokenExpiresIn * 1000);
    }
    if (response.scopes != null) {
      preferences.setStringList(scopesKey, response.scopes.split(' '));
    }
    return fromStore();
  }

  Future<AccessToken> fromStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String accessToken = preferences.getString(atKey);
    int atExpiresAtMillis = preferences.getInt(atExpiresAtKey);

    DateTime accessTokenExpiresAt = atExpiresAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(atExpiresAtMillis)
        : null;
    String refreshToken = preferences.getString(rtKey);
    int rtExpiresAtMillis = preferences.getInt(rtExpiresAtKey);
    DateTime refreshTokenExpiresAt = rtExpiresAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(rtExpiresAtMillis)
        : null;
    List<String> scopes = preferences.getStringList(scopesKey);

    return AccessToken(accessToken, accessTokenExpiresAt, refreshToken,
        refreshTokenExpiresAt, scopes);
  }
}
