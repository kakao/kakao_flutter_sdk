import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';
import 'package:kakao_flutter_sdk/src/story/model/link_info.dart';
import 'package:kakao_flutter_sdk/src/story/model/story.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_profile.dart';

class StoryApi {
  StoryApi(this.dio);
  final Dio dio;
  static final StoryApi instance = StoryApi(ApiFactory.authApi);

  Future<bool> isStoryUser() async {
    return ApiFactory.handleApiError(() async {
      final response = await dio.get("/v1/api/story/isstoryuser");
      return response.data["isStoryUser"];
    });
  }

  Future<StoryProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      final response = await dio.get("/v1/api/story/profile",
          queryParameters: {"secure_resource": "true"});
      return StoryProfile.fromJson(response.data);
    });
  }

  Future<Story> myStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      final response = await dio
          .get("/v1/api/story/mystory", queryParameters: {"id": storyId});
      return Story.fromJson(response.data);
    });
  }

  Future<List<Story>> myStories([String lastId]) async {
    return ApiFactory.handleApiError(() async {
      final response = await dio.get("/v1/api/story/mystories",
          queryParameters: lastId == null ? {} : {"last_id": lastId});
      final data = response.data;
      if (data is List) {
        return data.map((entry) => Story.fromJson(entry)).toList();
      }
      throw KakaoClientException("Stories response is not a json array.");
    });
  }

  Future<String> postNote(String content,
          {StoryPermission permission,
          bool enableShare,
          String androidExecParams,
          String iosExecParams,
          String androidMarketParams,
          String iosMarketParams}) =>
      _post(
          content: content,
          permission: permission,
          enableShare: enableShare,
          androidExecParams: androidExecParams,
          iosExecParams: iosExecParams,
          androidMarketParams: androidMarketParams,
          iosMarketParams: iosMarketParams);

  Future<String> postPhotos(List<String> images,
          {String content,
          StoryPermission permission,
          bool enableShare,
          String androidExecParams,
          String iosExecParams,
          String androidMarketParams,
          String iosMarketParams}) =>
      _post(
          images: images,
          permission: permission,
          enableShare: enableShare,
          androidExecParams: androidExecParams,
          iosExecParams: iosExecParams,
          androidMarketParams: androidMarketParams,
          iosMarketParams: iosMarketParams);

  Future<String> postLink(LinkInfo linkInfo,
          {String content,
          StoryPermission permission,
          bool enableShare,
          String androidExecParams,
          String iosExecParams,
          String androidMarketParams,
          String iosMarketParams}) =>
      _post(
          linkInfo: linkInfo,
          permission: permission,
          enableShare: enableShare,
          androidExecParams: androidExecParams,
          iosExecParams: iosExecParams,
          androidMarketParams: androidMarketParams,
          iosMarketParams: iosMarketParams);

  Future<String> _post(
      {String content,
      List<String> images,
      LinkInfo linkInfo,
      StoryPermission permission,
      bool enableShare,
      String androidExecParams,
      String iosExecParams,
      String androidMarketParams,
      String iosMarketParams}) async {
    return ApiFactory.handleApiError(() async {
      var postfix = images != null && images.isNotEmpty
          ? "photo"
          : linkInfo != null ? "link" : "note";
      var data = {
        "content": content,
        "image_url_list":
            images == null || images.isEmpty ? null : jsonEncode(images),
        "link_info": linkInfo == null ? null : jsonEncode(linkInfo),
        "permission": permissionToParams(permission),
        "enable_share": enableShare,
        "android_exec_param": androidExecParams,
        "ios_exec_param": iosExecParams,
        "android_market_param": androidMarketParams,
        "ios_market_param": iosMarketParams
      };
      data.removeWhere((k, v) => v == null);
      var response = await dio.post("/v1/api/story/post/$postfix", data: data);
      return response.data["id"];
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
      final response = await dio
          .get("/v1/api/story/linkinfo", queryParameters: {"url": url});
      return LinkInfo.fromJson(response.data);
    });
  }

  Future<List<String>> scrapImages(List<File> images) async {
    return ApiFactory.handleApiError(() async {
      Map<String, UploadFileInfo> data = images.asMap().map((index, image) =>
          MapEntry("file_${index + 1}",
              UploadFileInfo(image, image.path.split("/").last)));
      final response = await dio.post("/v1/api/story/upload/multi",
          data: FormData.from(data));
      var urls = response.data;
      if (urls is List) return urls.map((url) => url as String).toList();
      throw KakaoClientException("Resposne should be an array.");
    });
  }
}
