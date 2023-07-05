import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friends.dart';
import 'package:kakao_flutter_sdk_talk/src/model/talk_profile.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        String path = uriPathToFilePath(Constants.profilePath);
        String body = await loadJson('talk/$path/$data.json');
        Map<String, dynamic> expected = jsonDecode(body);
        TalkProfile actual = TalkProfile.fromJson(expected);

        expect(actual.nickname, expected['nickName']);
        expect(actual.profileImageUrl, expected['profileImageURL']);
        expect(actual.thumbnailUrl, expected['thumbnailURL']);
        expect(actual.countryISO, expected['countryISO']);
      });
    }

    parse('normal');
  });
}
