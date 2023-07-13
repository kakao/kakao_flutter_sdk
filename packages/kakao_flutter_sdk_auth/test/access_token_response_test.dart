import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('AccessTokenInfo Test', () {
    void parse(String data) {
      test(data, () async {
        String path = uriPathToFilePath(Constants.tokenPath);
        String body = await loadJson('auth/$path/$data.json');
        Map<String, dynamic> expected = jsonDecode(body);
        AccessTokenResponse actual = AccessTokenResponse.fromJson(expected);

        expect(expected['access_token'], actual.accessToken);
        expect(expected['token_type'], actual.tokenType);
        expect(expected['refresh_token'], actual.refreshToken);
        expect(expected['expires_in'], actual.expiresIn);
        expect(
            expected['refresh_token_expires_in'], actual.refreshTokenExpiresIn);
        expect(expected['scope'], actual.scope);
        expect(expected['tx_id'], actual.txId);
      });
    }

    parse('has_rt');
    parse('has_rt_and_scopes');
    parse('no_rt');
  });
}
