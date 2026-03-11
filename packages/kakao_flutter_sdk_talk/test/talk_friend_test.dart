import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friends.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';

void main() {
  group('parse test', () {
    void verifyJsonToModel(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v1FriendsPath);
        final body = await loadJson('talk/$path/$data.json');
        final expected = jsonDecode(body);
        final actual = Friends.fromJson(expected);

        expect(actual.totalCount, expected['total_count']);
        expect(actual.favoriteCount, expected['favorite_count']);
        expect(actual.beforeUrl, expected['before_url']);
        expect(actual.afterUrl, expected['after_url']);

        for (int i = 0; i < (actual.elements?.length ?? 0); i++) {
          final friend = actual.elements![i];
          final expectedFriend = expected['elements'][i];

          expect(friend.id, expectedFriend['id']);
          expect(friend.uuid, expectedFriend['uuid']);
          expect(friend.profileNickname, expectedFriend['profile_nickname']);
          expect(
            friend.profileThumbnailImage,
            expectedFriend['profile_thumbnail_image'],
          );
          expect(friend.favorite, expectedFriend['favorite']);
          expect(friend.allowedMsg, expectedFriend['allowed_msg']);
        }
      });
    }

    verifyJsonToModel('normal');
  });
}
