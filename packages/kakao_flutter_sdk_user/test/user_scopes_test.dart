import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/scope.dart';
import 'package:kakao_flutter_sdk_user/src/model/scope_info.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2ScopesPath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = ScopeInfo.fromJson(expected);

        expect(response.id, expected['id']);

        for (int i = 0; i < (response.scopes?.length ?? 0); i++) {
          var scope = response.scopes![i];
          var expectedScope = expected['scopes'][i];

          expect(scope.id, expectedScope['id']);
          expect(scope.displayName, expectedScope['display_name']);

          expect(
            scope.type,
            $enumDecode($ScopeTypeEnumMap, expectedScope['type']),
          );
          expect(scope.delegated, expectedScope['delegated']);
          expect(scope.agreed, expectedScope['agreed']);
          expect(scope.revocable, expectedScope['revocable']);
        }
      });
    }

    parse('scopes');
  });

  group('Enum Test', () {
    test('ScopeType Test', () {
      expect(ScopeType.privacy, $enumDecode($ScopeTypeEnumMap, 'PRIVACY'));
      expect(ScopeType.service, $enumDecode($ScopeTypeEnumMap, 'SERVICE'));
    });
  });
}
