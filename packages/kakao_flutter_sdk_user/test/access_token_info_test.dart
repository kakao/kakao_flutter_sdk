import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/access_token_info.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v1AccessTokenInfoPath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = AccessTokenInfo.fromJson(expected);

        expect(response.id, expected["id"]);
        expect(response.expiresIn, expected["expires_in"]);
        expect(response.appId, expected["app_id"]);
      });
    }

    parse('normal');
  });
}
