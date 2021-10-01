import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/auth/model/oauth_token.dart';
import 'package:kakao_flutter_sdk/src/auth/token_manager.dart';

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
    expect(newToken.scopes?.join(" "), response.scopes);
  });

  test("clear", () async {
    var token = OAuthToken.fromResponse(response);
    await tokenManager.setToken(token);
    await tokenManager.clear();
    var newToken = await tokenManager.getToken();
    expect(null, newToken);
  });
}
