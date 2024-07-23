import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2ServiceTermsPath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = UserServiceTerms.fromJson(expected);

        expect(response.id, expected['id']);

        for (int i = 0; i < (response.serviceTerms?.length ?? 0); i++) {
          var serviceTerm = response.serviceTerms![i];
          var expectedServiceTerm = expected['service_terms'][i];

          expect(serviceTerm.tag, expectedServiceTerm['tag']);
          expect(serviceTerm.required, expectedServiceTerm['required']);
          expect(serviceTerm.agreed, expectedServiceTerm['agreed']);
          expect(serviceTerm.revocable, expectedServiceTerm['revocable']);

          if (serviceTerm.agreedAt != null) {
            expect(serviceTerm.agreedAt,
                DateTime.parse(expectedServiceTerm['agreed_at']));
          }

          expect(
            serviceTerm.referer,
            $enumDecodeNullable(
              $RefererEnumMap,
              expectedServiceTerm['agreed_by'],
              unknownValue: Referer.unknown,
            ),
          );
        }
      });
    }

    parse('normal');
  });

  group('enum test', () {
    test('Referer Test', () {
      expect(Referer.kapi, $enumDecode($RefererEnumMap, 'KAPI', unknownValue: Referer.unknown));
      expect(Referer.kauth, $enumDecode($RefererEnumMap, 'KAUTH', unknownValue: Referer.unknown));
      expect(Referer.unknown, $enumDecode($RefererEnumMap, 'test', unknownValue: Referer.unknown));
    });
  });
}
