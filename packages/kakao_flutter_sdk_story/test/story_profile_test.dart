import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_profile.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.storyProfilePath);
        String body = await loadJson("story/$path/$data.json");
        var expected = jsonDecode(body);
        var response = StoryProfile.fromJson(expected);

        expect(response.nickname, expected['nickName']);
        expect(response.profileImageUrl, expected['profileImageURL']);
        expect(response.thumbnailUrl, expected['thumbnailURL']);
        expect(response.bgImageUrl, expected['bgImageURL']);
        expect(response.permalink, expected['permalink']);
        expect(response.birthday, expected['birthday']);
        expect(response.birthdayType, expected['birthdayType']);
      });
    }

    parse('normal');
  });
}
