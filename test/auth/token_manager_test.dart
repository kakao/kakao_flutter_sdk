import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';
import 'package:kakao_flutter_sdk/src/auth/token_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';

void main() {
  var map;
  var response;
  late DefaultTokenManager tokenManager;
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      if (methodCall.method.startsWith("set") ||
          methodCall.method == 'remove') {
        return true;
      }
      return null;
    });
    map = await loadJsonIntoMap('oauth/token_with_rt_and_scopes.json');
    response = AccessTokenResponse.fromJson(map);
    tokenManager = DefaultTokenManager();
  });
  tearDown(() {});

  test('toCache', () async {
    expect(response.accessToken, map["access_token"]);
    expect(response.refreshToken, map["refresh_token"]);
    await tokenManager.setToken(OAuthToken.fromResponse(response));
    var newToken = await tokenManager.getToken();
    expect(true, newToken != null);
    expect(newToken!.accessToken, response.accessToken);
    expect(newToken.refreshToken, response.refreshToken);
    expect(newToken.scopes?.join(" "), response.scope);
  });

  test("clear", () async {
    var token = OAuthToken.fromResponse(response);
    await tokenManager.setToken(token);
    await tokenManager.clear();
    var newToken = await tokenManager.getToken();
    expect(null, newToken);
  });

  test("token migration test", () async {
    var oldTokenManager = OldTokenManager();
    await oldTokenManager.setToken(OAuthToken.fromResponse(response));
    final oldToken = await oldTokenManager.getToken();
    expect(true, oldToken != null);
    final newToken = await tokenManager.getToken();
    expect(true, newToken != null);

    try {
      final prevToken = await oldTokenManager.getToken();
      fail("should not reach here");
    } catch (e) {}
  });
}

const tokenKey = "com.kakao.token.OAuthToken";
const atKey = "com.kakao.token.AccessToken";
const atExpiresAtKey = "com.kakao.token.AccessToken.ExpiresAt";
const rtKey = "com.kakao.token.RefreshToken";
const rtExpiresAtKey = "com.kakao.token.RefreshToken.ExpiresAt";
const secureModeKey = "com.kakao.token.KakaoSecureMode";
const scopesKey = "com.kakao.token.Scopes";

// old version token manager ( ~ 0.8.2)
class OldTokenManager implements TokenManager {
  @override
  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(atKey);
    await preferences.remove(atExpiresAtKey);
    await preferences.remove(rtKey);
    await preferences.remove(rtExpiresAtKey);
    await preferences.remove(secureModeKey);
    await preferences.remove(scopesKey);
  }

  @override
  Future<OAuthToken?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString(atKey);
    var atExpiresAtMillis = preferences.getInt(atExpiresAtKey);

    var accessTokenExpiresAt = atExpiresAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(atExpiresAtMillis)
        : null;
    var refreshToken = preferences.getString(rtKey);
    var rtExpiresAtMillis = preferences.getInt(rtExpiresAtKey);
    var refreshTokenExpiresAt = rtExpiresAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(rtExpiresAtMillis)
        : null;
    List<String>? scopes = preferences.getStringList(scopesKey);

    return OAuthToken(accessToken!, accessTokenExpiresAt!, refreshToken!,
        refreshTokenExpiresAt!, scopes);
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(atKey, token.accessToken);
    await preferences.setInt(
        atExpiresAtKey, token.accessTokenExpiresAt.millisecondsSinceEpoch);
    await preferences.setString(rtKey, token.refreshToken);
    await preferences.setInt(
        rtExpiresAtKey, token.refreshTokenExpiresAt.millisecondsSinceEpoch);
    await preferences.setStringList(scopesKey, token.scopes!);
  }
}
