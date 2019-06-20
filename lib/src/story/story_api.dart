import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/api_factory.dart';
import 'package:kakao_flutter_sdk/src/kakao_error.dart';
import 'package:kakao_flutter_sdk/src/story/model/link_info.dart';
import 'package:kakao_flutter_sdk/src/story/model/story.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_profile.dart';

export 'package:kakao_flutter_sdk/src/story/model/story_profile.dart';
export 'package:kakao_flutter_sdk/src/story/model/story.dart';

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

  Future<Story> myStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio
          .get("/v1/api/story/mystory", queryParameters: {"id": storyId});
      return Story.fromJson(response.data);
    });
  }

  Future<List<Story>> myStories([String lastStoryId]) async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.get("/v1/api/story/mystories",
          queryParameters: {"last_id": lastStoryId});
      var data = response.data;
      if (data is List) {
        return data.map((entry) => Story.fromJson(entry)).toList();
      }
      throw KakaoClientError();
    });
  }

  Future<Story> post(
      {String content,
      List<String> images,
      String url,
      StoryPermission permission,
      bool enableShare,
      String androidExecParams,
      String iosExecParams,
      String androidMarketParams,
      String iosParmetParams}) async {
    return ApiFactory.handleApiError(() async {
      var postfix = images != null ? "photo" : url != null ? "link" : "note";
      var data = {
        "content": content,
        "images": jsonEncode(images),
        "url": url,
        "permission": permissionToParams(permission),
        "enable_share": enableShare,
        "android_exec_param": androidExecParams,
        "ios_exec_param": iosExecParams,
        "android_market_param": androidMarketParams,
        "ios_market_param": iosParmetParams
      };
      data.removeWhere((k, v) => v == null);
      var response = await dio.post("/v1/api/story/post/$postfix", data: data);
      return Story.fromJson(response.data);
    });
  }

  Future<void> deleteStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      await dio.delete("/v1/api/story/delete/mystory",
          queryParameters: {"id": storyId});
    });
  }

  Future<LinkInfo> scrapLink(String url) async {
    return ApiFactory.handleApiError(() async {
      Response response = await dio
          .get("/v1/api/story/linkinfo", queryParameters: {"url": url});
      return LinkInfo.fromJson(response.data);
    });
  }

  Future<List<String>> scrapImages(List<File> images) async {
    return ApiFactory.handleApiError(() async {
      Map<String, UploadFileInfo> data = images.asMap().map((index, image) =>
          MapEntry("file_${index + 1}",
              UploadFileInfo(image, image.path.split("/").last)));
      Response response = await dio.post("/v1/api/story/upload/multi",
          data: FormData.from(data));
      return response.data;
    });
  }
}
