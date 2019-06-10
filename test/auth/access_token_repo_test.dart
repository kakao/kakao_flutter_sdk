import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src//auth/access_token_repo.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';

import '../helper.dart';

void main() {
  setUp(() {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
  });
  tearDown(() {});

  test('toCache', () async {
    var normal = await loadJsonIntoMap('auth/token_with_rt_and_scopes.json');
    var response = AccessTokenResponse.fromJson(normal);

    expect(response.accessToken, normal["access_token"]);
    expect(response.refreshToken, normal["refresh_token"]);

    var repo = AccessTokenRepo();
    var token = await repo.toCache(response);
    expect(token.accessToken, response.accessToken);
    expect(token.refreshToken, response.refreshToken);
    expect(token.scopes.join(" "), response.scopes); // null
  });
}
