import 'dart:convert';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTokenManager extends TokenManager {
  static const tokenKey = "test_token_key";

  @override
  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(tokenKey);
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

  @override
  Future<void> setToken(OAuthToken token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(tokenKey, jsonEncode(token));
  }
}
