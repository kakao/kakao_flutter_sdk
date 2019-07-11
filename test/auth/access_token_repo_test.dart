import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src//auth/access_token_repo.dart';
import 'package:kakao_flutter_sdk/src/auth/access_token_repo.dart' as prefix0;
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';

import '../helper.dart';

void main() {
  var map;
  var response;
  AccessTokenRepo repo;
  setUp(() async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
    map = await loadJsonIntoMap('auth/token_with_rt_and_scopes.json');
    response = AccessTokenResponse.fromJson(map);
    repo = AccessTokenRepo();
  });
  tearDown(() {});

  test('toCache', () async {
    expect(response.accessToken, map["access_token"]);
    expect(response.refreshToken, map["refresh_token"]);
    var token = await repo.toCache(response);
    expect(token.accessToken, response.accessToken);
    expect(token.refreshToken, response.refreshToken);
    expect(token.scopes.join(" "), response.scopes); // null
    expect(true, token.toString() != null);
  });

  test("clear", () async {
    await repo.toCache(response);
    await repo.clear();
    var token = await repo.fromCache();
    expect(null, token.accessToken);
    expect(null, token.accessTokenExpiresAt);
    expect(null, token.refreshToken);
    expect(null, token.refreshTokenExpiresAt);
    expect(null, token.scopes);
  });
}
