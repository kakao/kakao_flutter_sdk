import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';
import 'package:kakao_flutter_sdk_story/src/model/story.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(Map<String, dynamic> expected, Story response) {
      expect(response.id, expected['id']);
      expect(response.url, expected['url']);

      if (response.mediaType != null) {
        expect(
          response.mediaType,
          $enumDecode($StoryTypeEnumMap, expected['media_type']),
        );
      }

      expect(response.createdAt, DateTime.parse(expected['created_at']));
      expect(response.commentCount, expected['comment_count']);

      expect(response.content, expected['content']);

      if (response.permission != null) {
        expect(
          response.permission,
          $enumDecode($StoryPermissionEnumMap, expected['permission']),
        );
      }

      for (int i = 0; i < (response.media?.length ?? 0); i++) {
        var media = response.media![i];
        var expectedMedia = expected['media'][i];
        expect(media.xlarge, expectedMedia['xlarge']);
        expect(media.large, expectedMedia['large']);
        expect(media.medium, expectedMedia['medium']);
        expect(media.small, expectedMedia['small']);
        expect(media.original, expectedMedia['original']);
      }

      for (int i = 0; i < (response.likes?.length ?? 0); i++) {
        var like = response.likes![i];
        var actor = like.actor;
        var emotion = like.emotion;
        var expectedLike = expected['likes'][i];
        var expectedActor = expectedLike['actor'];
        var expectedEmotion = expectedLike['emotion'];

        expect(actor.displayName, expectedActor['display_name']);
        expect(
          actor.profileThumbnailUrl,
          expectedActor['profile_thumbnail_url'],
        );
        expect(emotion, $enumDecode($EmotionEnumMap, expectedEmotion));
      }

      for (int i = 0; i < (response.comments?.length ?? 0); i++) {
        var comment = response.comments![i];
        var writer = comment.writer;

        var expectedComment = expected['comments'][i];
        var expectedWriter = expectedComment['writer'];
        expect(comment.text, expectedComment['text']);

        expect(writer.displayName, expectedWriter['display_name']);
        expect(
          writer.profileThumbnailUrl,
          expectedWriter['profile_thumbnail_url'],
        );
      }
    }

    void story(String data) {
      test(Constants.getStoryPath, () async {
        final path = uriPathToFilePath(Constants.getStoryPath);
        String body = await loadJson("story/$path/$data.json");
        var expected = jsonDecode(body);
        var response = Story.fromJson(expected);

        parse(expected, response);
      });
    }

    void stories(String data) async {
      test(Constants.getStoriesPath, () async {
        final path = uriPathToFilePath(Constants.getStoriesPath);
        String body = await loadJson("story/$path/$data.json");
        var expected = jsonDecode(body);

        var length = (expected as List).length;
        for (int i = 0; i < length; i++) {
          var expectedStory = expected[i];
          var response = Story.fromJson(expectedStory);

          parse(expectedStory, response);
        }
      });
    }

    // story('normal');
    stories('normal');
  });

  group('enum test', () {
    test('StoryType', () {
      expect(StoryType.note, $enumDecode($StoryTypeEnumMap, 'NOTE'));
      expect(StoryType.photo, $enumDecode($StoryTypeEnumMap, 'PHOTO'));
      expect(
        StoryType.notSupported,
        $enumDecode($StoryTypeEnumMap, 'NOT_SUPPORTED'),
      );
    });

    test('permission', () {
      expect(StoryPermission.public, $enumDecode($StoryPermissionEnumMap, 'PUBLIC'));
      expect(StoryPermission.onlyMe, $enumDecode($StoryPermissionEnumMap, 'ONLY_ME'));
      expect(StoryPermission.friend, $enumDecode($StoryPermissionEnumMap, 'FRIEND'));
    });
  });
}
