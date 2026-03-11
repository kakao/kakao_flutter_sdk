import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/talk_profile.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';

void main() {
  group('parse test', () {
    void verifyJsonToModel(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.profilePath);
        final body = await loadJson('talk/$path/$data.json');
        final expected = jsonDecode(body);
        final actual = TalkProfile.fromJson(expected);

        expect(actual.nickname, expected['nickName']);
        expect(actual.profileImageUrl, expected['profileImageURL']);
        expect(actual.thumbnailUrl, expected['thumbnailURL']);
        expect(actual.countryISO, expected['countryISO']);
      });
    }

    verifyJsonToModel('normal');
  });
}
