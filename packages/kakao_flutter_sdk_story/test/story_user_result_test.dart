import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.isStoryUserPath);
        String body = await loadJson("story/$path/$data.json");
        var expected = jsonDecode(body);
        expect(expected['isStoryUser'] is bool, true);
      });
    }

    parse('normal');
  });
}
