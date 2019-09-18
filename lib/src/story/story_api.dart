import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';
import 'package:kakao_flutter_sdk/src/story/model/link_info.dart';
import 'package:kakao_flutter_sdk/src/story/model/story.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_profile.dart';

/// Provides KakaoStory API.
class StoryApi {
  StoryApi(this._dio);
  final Dio _dio;

  /// Default instance SDK provides.
  static final StoryApi instance = StoryApi(ApiFactory.authApi);

  /// Check whether current user is a KakaoStory user or not.
  Future<bool> isStoryUser() async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v1/api/story/isstoryuser");
      return response.data["isStoryUser"];
    });
  }

  /// Fetches current user's KakaoStory profile.
  Future<StoryProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v1/api/story/profile",
          queryParameters: {"secure_resource": "true"});
      return StoryProfile.fromJson(response.data);
    });
  }

  /// Fetches an individual story with the given id.
  Future<Story> myStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio
          .get("/v1/api/story/mystory", queryParameters: {"id": storyId});
      return Story.fromJson(response.data);
    });
  }

  /// Fetches a list of stories where id is smaller the given lastId.
  Future<List<Story>> myStories([String lastId]) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v1/api/story/mystories",
          queryParameters: lastId == null ? {} : {"last_id": lastId});
      final data = response.data;
      if (data is List) {
        return data.map((entry) => Story.fromJson(entry)).toList();
      }
      throw KakaoClientException("Stories response is not a json array.");
    });
  }

  /// Posts a story with a simple content text.
  ///
  /// @param enableShare Whether friends can share this story if [permission] is [StoryPermission.FRIEND]. (default is false) Always always true if [permission] is [StoryPermission.PUBLIC].
  /// @param androidExecParams Query string to be passed to custom scheme in Android.
  /// @param iosExecParams Query string to be passed to custom scheme in iOS.
  /// @param androidMarketParms Query string to be passed to Google play market url.
  /// @param iosMarketParams Query string to be passed to App Store url.
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

  /// Posts a story with a list of image urls returned by [StoryApi.scrapImages()].
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

  /// Posts a story with a [LinkInfo] returned by [StoryApi.scrapLink()].
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
      var response = await _dio.post("/v1/api/story/post/$postfix", data: data);
      return response.data["id"];
    });
  }

  Future<void> deleteStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      await _dio.delete("/v1/api/story/delete/mystory",
          queryParameters: {"id": storyId});
    });
  }

  /// Gets a scraping result with the given url.
  ///
  /// Returned [LinkInfo] can be used by [StoryApi.postLink()].
  Future<LinkInfo> scrapLink(String url) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio
          .get("/v1/api/story/linkinfo", queryParameters: {"url": url});
      return LinkInfo.fromJson(response.data);
    });
  }

  /// Uploads a list of images to storage server used by Kakao API.
  ///
  /// Returned list of image urls can be passed to [StoryApi.postPhotos()].
  Future<List<String>> scrapImages(List<File> images) async {
    return ApiFactory.handleApiError(() async {
      List<MultipartFile> files = await Future.wait(images.map((image) async =>
          await MultipartFile.fromFile(image.path,
              filename: image.path.split("/").last)));
      Map<String, MultipartFile> data = files.asMap().map((index, file) {
        return MapEntry("file_${index + 1}", file);
      });
      final response = await _dio.post("/v1/api/story/upload/multi",
          data: FormData.fromMap(data));
      var urls = response.data;
      if (urls is List) return urls.map((url) => url as String).toList();
      throw KakaoClientException("Resposne should be an array.");
    });
  }
}
