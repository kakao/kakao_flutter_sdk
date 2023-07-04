import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.scrapImagesPath);
        String body = await loadJsonFromRepository("story/$path/$data.json");
        var expected = jsonDecode(body);
        var length = (expected as List).length;

        expect(length > 0, true);

        for (int i = 0; i < length; i++) {
          expect(expected[i] is String, true);
        }
      });
    }

    parse('normal');
  });
}
