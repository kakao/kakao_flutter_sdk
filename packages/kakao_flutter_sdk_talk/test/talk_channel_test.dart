import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channels.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        String path = uriPathToFilePath(Constants.v2ChannelsPath);
        String body = await loadJson('talk/$path/$data.json');
        Map<String, dynamic> expected = jsonDecode(body);
        Channels actual = Channels.fromJson(expected);

        expect(actual.userId, expected['user_id']);

        for (int i = 0; i < (actual.channels?.length ?? 0); i++) {
          var channel = actual.channels![i];
          Map<String, dynamic> expectedChannel = expected['channels'][i];

          expect(channel.uuid, expectedChannel['channel_uuid']);
          expect(channel.encodedId, expectedChannel['channel_public_id']);
          expect(
              channel.updatedAt, DateTime.parse(expectedChannel['updated_at']));
        }
      });
    }

    parse('normal');
  });
}
