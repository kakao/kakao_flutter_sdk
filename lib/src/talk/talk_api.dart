import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/talk/model/friends_response.dart';
import 'package:kakao_flutter_sdk/src/talk/model/plus_friends_response.dart';
import 'package:kakao_flutter_sdk/src/talk/model/talk_profile.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';

/// Provides KakaoTalk API.
class TalkApi {
  TalkApi(this._dio);

  final Dio _dio;

  /// Default instance SDK provides.
  static final TalkApi instance = TalkApi(ApiFactory.authApi);

  /// Fetches current user's KakaoTalk profile.
  Future<TalkProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/api/talk/profile",
          queryParameters: {"secure_resource": true});
      return TalkProfile.fromJson(response.data);
    });
  }

  Future<void> customMemo(int templateId,
      [Map<String, String> templateArgs]) async {
    var params = {
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _memo("", params);
  }

  Future<void> defaultMemo(DefaultTemplate template) async {
    return _memo("default/", {"template_object": jsonEncode(template)});
  }

  Future<void> scrapMemo(String url,
      {int templateId, Map<String, String> templateArgs}) async {
    var params = {
      "request_url": url,
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _memo("scrap/", params);
  }

  Future<void> _memo(String pathPart, Map<String, dynamic> params) async {
    params.removeWhere((k, v) => v == null);
    return ApiFactory.handleApiError(() async {
      await _dio.post("/v2/api/talk/memo/${pathPart}send", data: params);
    });
  }

  Future<PlusFriendsResponse> plusFriends([List<String> publicIds]) async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/api/talk/plusfriends",
          queryParameters: publicIds == null
              ? {}
              : {"plus_friend_public_ids": jsonEncode(publicIds)});
      return PlusFriendsResponse.fromJson(response.data);
    });
  }

  /// Fetches a list of current user's KakaoTalk friends.
  ///
  /// However, not all friends are returned by this API. They are filtered by the following criteria:
  ///
  /// 1. Connected to the application
  /// 1. Agreed to use Friends API in /oauth/authorize.
  ///
  Future<FriendsResponse> friends({int offset, int limit, String order}) async {
    return ApiFactory.handleApiError(() async {
      var params = {
        "offset": offset,
        "limit": limit,
        "order": order,
        "secure_resource": true
      };
      params.removeWhere((k, v) => v == null);
      Response response =
          await _dio.get("/v1/friends", queryParameters: params);
      return FriendsResponse.fromJson(response.data);
    });
  }
}
