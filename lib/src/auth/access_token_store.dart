import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores access token and refresh token from [AuthApi].
///
/// This abstract class can be used to store token information in different locations than provided by the SDK.
abstract class AccessTokenStore {
  // stores access token and other retrieved information from [AuthApi.issueAccessToken]
  Future<AccessToken> toStore(AccessTokenResponse response);

  // retrieves access token and other information from the designated store.
  Future<AccessToken> fromStore();

  // clears all data related to access token from the device.
  Future<void> clear();

  // singleton instance of the default [AccessTokenStore] used by the SDK.
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

    final refreshToken = response.refreshToken;
    final refreshTokenExpiresIn = response.refreshTokenExpiresIn;
    if (refreshToken != null && refreshTokenExpiresIn != null) {
      preferences.setString(rtKey, refreshToken);
      preferences.setInt(rtExpiresAtKey,
          DateTime.now().millisecondsSinceEpoch + refreshTokenExpiresIn * 1000);
    }

    final scopes = response.scopes;
    if (scopes != null) {
      preferences.setStringList(scopesKey, scopes.split(' '));
    }
    return fromStore();
  }

  Future<AccessToken> fromStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? accessToken = preferences.getString(atKey);
    int? atExpiresAtMillis = preferences.getInt(atExpiresAtKey);

    DateTime? accessTokenExpiresAt = atExpiresAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(atExpiresAtMillis)
        : null;
    String? refreshToken = preferences.getString(rtKey);
    int? rtExpiresAtMillis = preferences.getInt(rtExpiresAtKey);
    DateTime? refreshTokenExpiresAt = rtExpiresAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(rtExpiresAtMillis)
        : null;
    List<String>? scopes = preferences.getStringList(scopesKey);

    return AccessToken(accessToken, accessTokenExpiresAt, refreshToken,
        refreshTokenExpiresAt, scopes);
  }
}
