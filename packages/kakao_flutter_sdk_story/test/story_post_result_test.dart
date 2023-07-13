import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_story/kakao_flutter_sdk_story.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_profile.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath('${Constants.postPath}/note');
        String body = await loadJson("story/$path/$data.json");
        var expected = jsonDecode(body);
        var response = StoryPostResult.fromJson(expected);

        expect(response.id, expected['id']);
      });
    }

    parse('normal');
  });
}
