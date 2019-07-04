import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/story/story_api.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  MockAdapter _adapter;
  StoryApi _api;
  Dio _dio;
  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _api = StoryApi(_dio);
  });

  test("/v1/api/story/isstoryuser 200", () async {
    String body = jsonEncode({"isStoryUser": true});
    _adapter.setResponseString(body, 200);
    bool isUser = await _api.isStoryUser();
    expect(isUser, true);
  });

  test("/v1/api/story/profile", () async {
    String body = await loadJson("story/profile.json");
    _adapter.setResponseString(body, 200);
    var map = jsonDecode(body);
    var profile = await _api.profile();
    expect(profile.nickname, map["nickName"]);
    expect(profile.profileImageUrl, map["profileImageURL"]);
    expect(profile.thumbnailUrl, map["thumbnailURL"]);
    expect(profile.permalink, map["permalink"]);
    expect(profile.birthday, map["birthday"]);
    expect(profile.birthdayType, map["birthdayType"]);
  });

  test("/v1/api/story/mystories 200", () async {
    String body = await loadJson("story/stories.json");
    _adapter.setResponseString(body, 200);
    var stories = await _api.myStories();
    expect(stories.length, 3);
  });

  test("/v1/api/story/mystory 200", () async {
    String body = await loadJson("story/story.json");
    _adapter.setResponseString(body, 200);

    var story = await _api.myStory("AAAAAAA.CCCCCCCCCCC");
    var likes = story.likes;
    expect(likes[0].emoticon, Emoticon.COOL);
    expect(story.permission, StoryPermission.PUBLIC);
  });
}
