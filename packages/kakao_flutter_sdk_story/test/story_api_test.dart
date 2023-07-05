import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_story/kakao_flutter_sdk_story.dart';
import 'package:kakao_flutter_sdk_story/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';

void main() {
  late MockAdapter adapter;
  late StoryApi api;
  late Dio dio;

  setUp(() {
    dio = Dio();
    adapter = MockAdapter();
    dio.httpClientAdapter = adapter;
    api = StoryApi(dio);
  });

  test("/v1/api/story/isstoryuser 200", () async {
    final path = uriPathToFilePath(Constants.isStoryUserPath);
    String body = await loadJson('story/$path/normal.json');
    adapter.setResponseString(body, 200);
    bool isUser = await api.isStoryUser();
    expect(isUser, true);
  });

  test("/v1/api/story/profile", () async {
    final path = uriPathToFilePath(Constants.storyProfilePath);
    String body = await loadJson("story/$path/normal.json");
    adapter.setResponseString(body, 200);
    var map = jsonDecode(body);
    var profile = await api.profile();
    expect(profile.nickname, map["nickName"]);
    expect(profile.profileImageUrl.toString(), map["profileImageURL"]);
    expect(profile.thumbnailUrl.toString(), map["thumbnailURL"]);
    expect(profile.permalink.toString(), map["permalink"]);
    expect(profile.birthday, map["birthday"]);
    expect(profile.birthdayType, map["birthdayType"]);
  });

  test("/v1/api/story/mystories 200", () async {
    final path = uriPathToFilePath(Constants.getStoriesPath);
    String body = await loadJson("story/$path/normal.json");
    adapter.setResponseString(body, 200);
    var stories = await api.stories();
    expect(stories.length, 3);
  });

  test("/v1/api/story/mystory 200", () async {
    final path = uriPathToFilePath(Constants.getStoryPath);
    String body = await loadJson("story/$path/normal.json");
    adapter.setResponseString(body, 200);

    var story = await api.story("AAAAAAA.CCCCCCCCCCC");
    var likes = story.likes;
    expect(story.mediaType, StoryType.photo);
    expect(likes?[0].emotion, Emotion.cool);
    // expect(story.permission, StoryPermission.public);
  });

  group("/v1/api/story/delete/mystory", () {
    test("with id", () async {
      adapter.setResponseString("", 200);
      var storyId = "AAAAAAA.CCCCCCCCCCC";
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "DELETE");
        expect(options.path, "/v1/api/story/delete/mystory");
        var params = options.queryParameters;
        expect(params["id"], storyId);
      };
      await api.delete(storyId);
    });
  });

  test("/v1/api/story/linkinfo 200", () async {
    final path = uriPathToFilePath(Constants.scrapLinkPath);
    String body = await loadJson("story/$path/normal.json");
    var map = jsonDecode(body);
    adapter.setResponseString(body, 200);

    var url = "https://developers.kakao.com";
    adapter.requestAssertions = (RequestOptions options) {
      expect(options.method, "GET");
      expect(options.path, "/v1/api/story/linkinfo");
      var params = options.queryParameters;
      expect(params["url"], url);
    };
    var info = await api.linkInfo(url);

    expect(info.url.toString(), map["url"]);
    expect(info.requestedUrl.toString(), map["requested_url"]);
    expect(info.section, map["section"]);
    expect(info.title, map["title"]);
    expect(info.type, map["type"]);
    expect(info.description, map["description"]);
    expect(info.host, map["host"]);
  });

  group("/v1/api/story/post", () {
    Map<String, dynamic>? map;
    setUp(() async {
      final path = uriPathToFilePath('${Constants.postPath}/note');
      map = await loadJsonIntoMap('story/$path/normal.json');
      adapter.setResponseString(jsonEncode(map), 200);
    });
    test("/note with minimal params", () async {
      var content = "Story posting...";
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/v1/api/story/post/note");
        Map<String, dynamic> params = options.data;
        expect(params.keys.length, 3);
      };
      var storyPostResult = await api.postNote(content: content);
      expect(storyPostResult.id, map!["id"]);
    });

    test("/photo", () async {
      var images = [
        "https://developers.kakao.com/image1.png",
        "https://developers.kakao.com/image1.png",
        "https://developers.kakao.com/image1.png"
      ];

      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/v1/api/story/post/photo");
        Map<String, dynamic> params = options.data;
        expect(params.keys.length, 2);

        var urls = jsonDecode(params["image_url_list"]) as List<dynamic>;
        expect(urls.length, 3);
      };
      var storyPostResult = await api.postPhoto(
          images: images, permission: StoryPermission.friend);
      expect(storyPostResult.id, map!["id"]);
    });

    test("/link", () async {
      final path = uriPathToFilePath(Constants.scrapLinkPath);
      var bodyMap =
          jsonDecode(await loadJson("story/$path/normal.json"));
      var linkInfo = LinkInfo.fromJson(bodyMap);
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/v1/api/story/post/link");
        Map<String, dynamic> params = options.data;
        expect(params.length, 3);
      };
      var storyPostResult = await api.postLink(
        linkInfo: linkInfo,
        enableShare: false,
        androidExecParam: {"key1": "value1", "key2": "value2"},
      );
      expect(storyPostResult.id, map!["id"]);
    });
  });

  group("/v1/api/story/upload/multi", () {
    test("200", () async {
      final path = uriPathToFilePath(Constants.scrapImagesPath);
      var body = await loadJson("story/$path/normal.json");
      var urls = jsonDecode(body);

      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        expect(options.path, "/v1/api/story/upload/multi");
      };
      adapter.setResponseString(body, 200);
      var files = [
        File("../../example/assets/images/cat1.png"),
        File("../../example/assets/images/cat2.png")
      ];

      var res = await api.upload(files);
      expect(res, urls);
    });
  });
}
