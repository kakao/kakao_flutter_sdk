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

  group("/v1/api/story/delete/mystory", () {
    test("with id", () async {
      _adapter.setResponseString("", 200);
      var storyId = "AAAAAAA.CCCCCCCCCCC";
      _adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "DELETE");
        expect(options.path, "/v1/api/story/delete/mystory");
        var params = options.queryParameters;
        expect(params["id"], storyId);
      };
      await _api.deleteStory(storyId);
    });
  });

  test("/v1/api/story/linkinfo 200", () async {
    var body = await loadJson("story/linkinfo.json");
    var map = jsonDecode(body);
    _adapter.setResponseString(body, 200);

    var url = "https://developers.kakao.com";
    _adapter.requestAssertions = (RequestOptions options) {
      expect(options.method, "GET");
      expect(options.path, "/v1/api/story/linkinfo");
      var params = options.queryParameters;
      expect(params["url"], url);
    };
    var info = await _api.scrapLink(url);

    expect(info.url, map["url"]);
    expect(info.requestedUrl, map["requested_url"]);
    expect(info.section, map["section"]);
    expect(info.title, map["title"]);
    expect(info.type, map["type"]);
    expect(info.description, map["description"]);
    expect(info.host, map["host"]);
  });
}
