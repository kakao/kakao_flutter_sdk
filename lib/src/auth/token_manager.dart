import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores access token and refresh token from [AuthApi].
///
/// This abstract class can be used to store token information in different locations than provided by the SDK.
abstract class TokenManager {
  // stores access token and other retrieved information from [AuthApi.issueAccessToken]
  Future<OAuthToken> setToken(AccessTokenResponse response);

  // retrieves access token and other information from the designated store.
  Future<OAuthToken> getToken();

  // clears all data related to access token from the device.
  Future<void> clear();

  // singleton instance of the default [TokenManager] used by the SDK.
  static final TokenManager instance = DefaultTokenManager();
}

/// Default [TokenManager] provided by Kakao Flutter SDK.
///
/// Currently uses SharedPreferences (on Android) and UserDefaults (on iOS).
class DefaultTokenManager implements TokenManager {
  static const atKey = "com.kakao.token.AccessToken";
  static const atExpiresAtKey = "com.kakao.token.AccessToken.ExpiresAt";
  static const rtKey = "com.kakao.token.RefreshToken";
  static const rtExpiresAtKey = "com.kakao.token.RefreshToken.ExpiresAt";
  static const secureModeKey = "com.kakao.token.KakaoSecureMode";
  static const scopesKey = "com.kakao.token.Scopes";

  /// Deletes all token information.
  clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(atKey);
    await preferences.remove(atExpiresAtKey);
    await preferences.remove(rtKey);
    await preferences.remove(rtExpiresAtKey);
    await preferences.remove(secureModeKey);
    await preferences.remove(scopesKey);
  }

  Future<OAuthToken> setToken(AccessTokenResponse response) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(atKey, response.accessToken);
    final oldToken = await getToken();

    final atExpiresAt =
        DateTime.now().millisecondsSinceEpoch + response.expiresIn * 1000;
    await preferences.setInt(atExpiresAtKey, atExpiresAt);

    var refreshToken;
    var rtExpiresAt;

    if (response.refreshToken != null) {
      // issue AccessToken and RefreshToken
      refreshToken = response.refreshToken;
      if (refreshToken != null && response.refreshTokenExpiresIn != null) {
        rtExpiresAt = DateTime.now().millisecondsSinceEpoch +
            response.refreshTokenExpiresIn! * 1000;
        await preferences.setString(rtKey, refreshToken);
        await preferences.setInt(rtExpiresAtKey, rtExpiresAt);
      }
    } else {
      // issue AccessToken only
      refreshToken = oldToken.refreshToken;
      rtExpiresAt = oldToken.refreshTokenExpiresAt?.millisecondsSinceEpoch;
    }

    var scopes;
    if (response.scopes != null) {
      scopes = response.scopes!.split(' ');
      await preferences.setStringList(scopesKey, scopes);
    } else {
      scopes = oldToken.scopes;
    }
    return OAuthToken(
        response.accessToken,
        DateTime.fromMillisecondsSinceEpoch(atExpiresAt),
        refreshToken,
        DateTime.fromMillisecondsSinceEpoch(rtExpiresAt),
        scopes);
  }

  Future<OAuthToken> getToken() async {
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

    return OAuthToken(accessToken, accessTokenExpiresAt, refreshToken,
        refreshTokenExpiresAt, scopes);
  }
}
