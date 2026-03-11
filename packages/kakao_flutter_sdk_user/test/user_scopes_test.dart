import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/scope.dart';
import 'package:kakao_flutter_sdk_user/src/model/scope_info.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2ScopesPath);
        final body = await loadJson('user/$path/$data.json');
        final Map<String, dynamic> expected = jsonDecode(body);
        final response = ScopeInfo.fromJson(expected);

        expect(response.id, expected['id']);

        for (int i = 0; i < (response.scopes?.length ?? 0); i++) {
          final scope = response.scopes![i];
          final expectedScope = expected['scopes'][i];

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
      expect(
        ScopeType.privacy,
        $enumDecode(
          $ScopeTypeEnumMap,
          'PRIVACY',
          unknownValue: ScopeType.unknown,
        ),
      );
      expect(
        ScopeType.service,
        $enumDecode(
          $ScopeTypeEnumMap,
          'SERVICE',
          unknownValue: ScopeType.unknown,
        ),
      );
      expect(
        ScopeType.unknown,
        $enumDecode($ScopeTypeEnumMap, 'test', unknownValue: ScopeType.unknown),
      );
    });
  });
}
