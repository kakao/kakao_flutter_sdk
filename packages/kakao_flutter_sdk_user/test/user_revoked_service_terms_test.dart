import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/user_revoked_service_terms.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2RevokeServiceTermsPath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = UserRevokedServiceTerms.fromJson(expected);

        expect(response.id, expected['id']);

        for (int i = 0; i < (response.revokedServiceTerms?.length ?? 0); i++) {
          var serviceTerm = response.revokedServiceTerms![i];
          var expectedServiceTerm = expected['revoked_service_terms'][i];

          expect(serviceTerm.tag, expectedServiceTerm['tag']);
          expect(serviceTerm.agreed, expectedServiceTerm['agreed']);
        }
      });
    }

    parse('normal');
  });
}
