import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../shared/utils/load_data.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final body = await loadJson('errors/auth_errors/$data.json');
        final expected = jsonDecode(body);
        final actual = KakaoAuthException.fromJson(expected);

        expect(
          actual.error,
          $enumDecode(
            $AuthErrorCauseEnumMap,
            expected['error'],
            unknownValue: AuthErrorCause.unknown,
          ),
        );
        expect(actual.errorDescription, expected['error_description']);
      });
    }

    parse('expired_refresh_token');
    parse('invalid_client');
    parse('misconfigured');
  });
}
