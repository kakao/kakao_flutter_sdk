import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';
import 'package:kakao_flutter_sdk_story/src/model/link_info.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.scrapLinkPath);
        String body = await loadJson("story/$path/$data.json");
        var expected = jsonDecode(body);
        var response = LinkInfo.fromJson(expected);

        expect(response.url, expected['url']);
        expect(response.requestedUrl, expected['requested_url']);
        expect(response.host, expected['host']);
        expect(response.title, expected['title']);
        expect(response.description, expected['description']);
        expect(response.section, expected['section']);
        expect(response.type, expected['type']);

        for (int i = 0; i < (response.images?.length ?? 0); i++) {
          var image = response.images![i];
          var expectedImage = expected['image'][i];
          expect(image, expectedImage);
        }
      });
    }

    parse('normal');
  });
}
