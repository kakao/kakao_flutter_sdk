import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/sharing_result.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(
          '${Constants.validatePath}/${Constants.defaultTemplate}',
        );
        final body = await loadJson('share/$path/$data.json');
        final expected = jsonDecode(body);
        final response = SharingResult.fromJson(expected);

        expect(response.templateId, expected['template_id']);
        expect(response.templateArgs, expected['template_args']);
        expect(response.templateMsg, expected['template_msg']);
        expect(response.argumentMsg, expected['argument_msg']);
        expect(response.warningMsg, expected['warning_msg']);
      });
    }

    parse('default_commerce');
    parse('default_feed');
    parse('default_list');
    parse('default_location');
    parse('default_text');
  });
}
