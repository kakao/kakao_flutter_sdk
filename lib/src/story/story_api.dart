import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/api_factory.dart';
import 'package:kakao_flutter_sdk/src/story/model/link_info.dart';
import 'package:kakao_flutter_sdk/src/story/model/story.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_profile.dart';

export 'package:kakao_flutter_sdk/src/story/model/story_profile.dart';

class StoryApi {
  StoryApi(this.dio);
  final Dio dio;
  static final StoryApi instance = StoryApi(ApiFactory.authApi);

  Future<bool> isStoryUser() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/api/story/isstoryuser");
      return response.data["isStoryUser"];
    });
  }

  Future<StoryProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/api/story/profile",
          queryParameters: {"secure_resource": "true"});
      return StoryProfile.fromJson(response.data);
    });
  }

  Future<Story> myStory() async {}

  Future<List<Story>> myStories() async {}

  Future<String> postNote() async {}

  Future<String> postPhoto() async {}

  Future<String> postLink() async {}

  Future<void> deleteStory(String id) async {}

  Future<Linkinfo> scrapLink(String url) async {}

  Future<List<String>> scrapImages() async {}
}
