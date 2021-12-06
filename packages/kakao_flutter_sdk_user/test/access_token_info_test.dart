import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_user/src/model/access_token_info.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  setUp(() {});
  tearDown(() {});

  test('decode access_token_info', () async {
    var normal = await loadJson("users/token_info.json");
    Map<String, dynamic> map = jsonDecode(normal);
    var tokenInfo = AccessTokenInfo.fromJson(map);
    // expect(tokenInfo.appId, map["appId"]);
    expect(tokenInfo.id, map["id"]);
    expect(tokenInfo.expiresIn, map["expires_in"]);
  });
}
