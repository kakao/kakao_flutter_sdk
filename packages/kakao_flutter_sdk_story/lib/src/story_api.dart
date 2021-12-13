import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_story/src/model/link_info.dart';
import 'package:kakao_flutter_sdk_story/src/model/story.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_profile.dart';

/// 카카오스토리 API 호출을 담당하는 클라이언트.
class StoryApi {
  StoryApi(this._dio);

  final Dio _dio;

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final StoryApi instance = StoryApi(AuthApiFactory.authApi);

  /// 카카오스토리 사용자인지 확인하기.
  Future<bool> isStoryUser() async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v1/api/story/isstoryuser");
      return response.data["isStoryUser"];
    });
  }

  /// 카카오스토리 프로필 가져오기.
  Future<StoryProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio.get("/v1/api/story/profile",
          queryParameters: {"secure_resource": "true"});
      return StoryProfile.fromJson(response.data);
    });
  }

  /// 카카오스토리의 특정 내 스토리 가져오기. comments, likes 등 각종 상세정보 포함.
  Future<Story> myStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio
          .get("/v1/api/story/mystory", queryParameters: {"id": storyId});
      return Story.fromJson(response.data);
    });
  }

  /// 카카오스토리의 내 스토리 여러 개 가져오기.
  /// 단, comments, likes 등의 상세정보는 없으며 이는 내스토리 정보 요청 [myStory] 통해 획득 가능.
  Future<List<Story>> myStories([String? lastId]) async {
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

  /// 카카오스토리에 글 스토리 쓰기.
  Future<String> postNote(String content,
          {StoryPermission? permission,
          bool? enableShare,
          String? androidExecParams,
          String? iosExecParams,
          String? androidMarketParams,
          String? iosMarketParams}) =>
      _post(
          content: content,
          permission: permission,
          enableShare: enableShare,
          androidExecParams: androidExecParams,
          iosExecParams: iosExecParams,
          androidMarketParams: androidMarketParams,
          iosMarketParams: iosMarketParams);

  /// 카카오스토리에 사진 스토리 쓰기.
  ///
  /// 먼저 올리고자 하는 사진 파일을 [upload]로 카카오 서버에 업로드하고 반환되는 path 목록을 파라미터로 사용.
  Future<String> postPhotos(List<String> images,
          {String? content,
          StoryPermission? permission,
          bool? enableShare,
          String? androidExecParams,
          String? iosExecParams,
          String? androidMarketParams,
          String? iosMarketParams}) =>
      _post(
          images: images,
          permission: permission,
          enableShare: enableShare,
          androidExecParams: androidExecParams,
          iosExecParams: iosExecParams,
          androidMarketParams: androidMarketParams,
          iosMarketParams: iosMarketParams);

  /// 카카오스토리에 링크 스토리 쓰기
  ///
  /// 먼저 포스팅하고자 하는 URL로 [scrapLink]를 호출하고 반환된 링크 정보를 파라미터로 사용.
  Future<String> postLink(LinkInfo linkInfo,
          {String? content,
          StoryPermission? permission,
          bool? enableShare,
          String? androidExecParams,
          String? iosExecParams,
          String? androidMarketParams,
          String? iosMarketParams}) =>
      _post(
          linkInfo: linkInfo,
          permission: permission,
          enableShare: enableShare,
          androidExecParams: androidExecParams,
          iosExecParams: iosExecParams,
          androidMarketParams: androidMarketParams,
          iosMarketParams: iosMarketParams);

  Future<String> _post(
      {String? content,
      List<String>? images,
      LinkInfo? linkInfo,
      StoryPermission? permission,
      bool? enableShare,
      String? androidExecParams,
      String? iosExecParams,
      String? androidMarketParams,
      String? iosMarketParams}) async {
    return ApiFactory.handleApiError(() async {
      var postfix = images != null && images.isNotEmpty
          ? "photo"
          : linkInfo != null
              ? "link"
              : "note";
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

  /// 카카오스토리의 특정 내 스토리 삭제.
  Future<void> deleteStory(String storyId) async {
    return ApiFactory.handleApiError(() async {
      await _dio.delete("/v1/api/story/delete/mystory",
          queryParameters: {"id": storyId});
    });
  }

  /// 포스팅하고자 하는 URL 을 스크랩하여 링크 정보 생성
  Future<LinkInfo> scrapLink(String url) async {
    return ApiFactory.handleApiError(() async {
      final response = await _dio
          .get("/v1/api/story/linkinfo", queryParameters: {"url": url});
      return LinkInfo.fromJson(response.data);
    });
  }

  /// 로컬 이미지 파일 여러장을 카카오스토리에 업로드
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
