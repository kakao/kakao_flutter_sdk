import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'helper.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        String body = await loadJsonFromRepository('errors/all/$data.json');
        Map<String, dynamic> expected = jsonDecode(body);
        KakaoApiException actual = KakaoApiException.fromJson(expected);

        expect(
          actual.code,
          $enumDecode($ApiErrorCauseEnumMap, expected['code']),
        );
        expect(actual.msg, expected['msg']);
        expect(actual.apiType, expected['api_type']);
        expect(actual.requiredScopes, expected['required_scopes']);
        expect(actual.allowedScopes, expected['allowed_scopes']);
      });
    }

    parse('already_registered');
    parse('api_limit_exceeded');
    parse('blocked_action');
    parse('illegal_param');
    parse('insufficient_scope');
    parse('internal_error');
    parse('invalid_activity_id');
    parse('invalid_app_key');
    parse('invalid_scrap_url');
    parse('invalid_token');
    parse('not_exist_account');
    parse('not_exist_prop');
    parse('not_exist_story_user');
    parse('not_exist_talk_user');
    parse('not_registered_user');
    parse('permission_denied');
    parse('story_upload_fail');
    parse('unsupported_api');
    parse('upload_number_exceeded');
    parse('upload_size_exceeded');
  });
}
