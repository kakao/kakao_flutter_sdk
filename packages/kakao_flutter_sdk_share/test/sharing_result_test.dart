import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        String path = uriPathToFilePath(
            '${Constants.validatePath}/${Constants.defaultTemplate}');
        String body = await loadJson('share/$path/$data.json');
        var expected = jsonDecode(body);
        var response = SharingResult.fromJson(expected);

        expect(response.templateId, expected['template_id']);
        expect(response.templateArgs, expected['template_args']);
        expect(response.templateMsg, expected['template_msg']);
        expect(response.argumentMsg, expected['argument_msg']);
        expect(response.warningMsg, expected['warning_msg']);
      });
    }

    parse("default_commerce");
    parse("default_feed");
    parse("default_list");
    parse("default_location");
    parse("default_text");
  });
}
