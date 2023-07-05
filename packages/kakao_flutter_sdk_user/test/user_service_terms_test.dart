import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/user_service_terms.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v1ServiceTermsPath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = UserServiceTerms.fromJson(expected);

        expect(response.userId, expected['user_id']);

        for (int i = 0; i < (response.allowedServiceTerms?.length ?? 0); i++) {
          var serviceTerm = response.allowedServiceTerms![i];
          var expectedServiceTerm = expected['allowed_service_terms'][i];

          expect(serviceTerm.tag, expectedServiceTerm['tag']);
          expect(serviceTerm.agreedAt, DateTime.parse(expectedServiceTerm['agreed_at']));
        }

        for (int i = 0; i < (response.appServiceTerms?.length ?? 0); i++) {
          var appServiceTerm = response.appServiceTerms![i];
          var expectedAppServiceTerm = expected['app_service_terms'][i];

          expect(appServiceTerm.tag, expectedAppServiceTerm['tag']);
          expect(appServiceTerm.createdAt, DateTime.parse(expectedAppServiceTerm['created_at']));
          expect(appServiceTerm.updatedAt, DateTime.parse(expectedAppServiceTerm['updated_at']));
        }
      });
    }

    parse('normal');
  });
}
