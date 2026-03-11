import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channels.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';

void main() {
  group('parse test', () {
    void verifyJsonToModel(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2ChannelsPath);
        final body = await loadJson('talk/$path/$data.json');
        final expected = jsonDecode(body);
        final actual = Channels.fromJson(expected);

        expect(actual.userId, expected['user_id']);

        for (int i = 0; i < (actual.channels?.length ?? 0); i++) {
          final channel = actual.channels![i];
          final expectedChannel = expected['channels'][i];

          expect(channel.uuid, expectedChannel['channel_uuid']);
          expect(channel.encodedId, expectedChannel['channel_public_id']);
          expect(
            channel.updatedAt,
            DateTime.parse(expectedChannel['updated_at']),
          );
        }
      });
    }

    verifyJsonToModel('normal');
  });
}
