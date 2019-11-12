import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/talk/model/friends_response.dart';
import 'package:kakao_flutter_sdk/src/talk/model/message_send_result.dart';
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
      {Map<String, String> templateArgs}) async {
    final params = {
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
    final params = {
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
  Future<FriendsResponse> friends(
      {int offset, int limit, FriendOrder friendOrder, String order}) async {
    return ApiFactory.handleApiError(() async {
      final params = {
        "offset": offset,
        "limit": limit,
        "friend_order": friendOrder == null
            ? null
            : describeEnum(friendOrder).toLowerCase(),
        "order": order,
        "secure_resource": true
      };
      params.removeWhere((k, v) => v == null);
      final response =
          await _dio.get("/v1/api/talk/friends", queryParameters: params);
      return FriendsResponse.fromJson(response.data);
    });
  }

  Future<MessageSendResult> customMessage(
      List<String> receiverUuids, int templateId,
      {Map<String, String> templateArgs}) async {
    final params = {
      "receiver_uuids": jsonEncode(receiverUuids),
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _message("", params);
  }

  Future<MessageSendResult> defaultMessage(
      List<String> receiverUuids, DefaultTemplate template) async {
    final params = {
      "receiver_uuids": jsonEncode(receiverUuids),
      "template_object": jsonEncode(template)
    };
    return _message("default/", params);
  }

  Future<MessageSendResult> scrapMessage(List<String> receiverUuids, String url,
      {int templateId, Map<String, String> templateArgs}) async {
    final params = {
      "receiver_uuids": jsonEncode(receiverUuids),
      "request_url": url,
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _message("scrap/", params);
  }

  Future<Uri> channelAddUrl(final String channelId) async {
    return Uri(
        scheme: "https",
        host: KakaoContext.hosts.pf,
        path: "/$channelId/friend",
        queryParameters: await _channelBaseParams());
  }

  Future<Uri> channelChatUrl(final String channelId) async {
    return Uri(
        scheme: "https",
        host: KakaoContext.hosts.pf,
        path: "/$channelId/chat",
        queryParameters: await _channelBaseParams());
  }

  Future<MessageSendResult> _message(
      String pathPart, Map<String, dynamic> params) async {
    return ApiFactory.handleApiError(() async {
      params.removeWhere((k, v) => v == null);
      final response = await _dio
          .post("/v1/api/talk/friends/message/${pathPart}send", data: params);
      return MessageSendResult.fromJson(response.data);
    });
  }

  Future<Map<String, String>> _channelBaseParams() async {
    return {
      "app_key": KakaoContext.clientId,
      "kakao_agent": await KakaoContext.kaHeader,
      "api_ver": "1.0"
    };
  }
}

enum FriendOrder {
  @JsonValue("nickname")
  NICKNAME,
  @JsonValue("favorite")
  FAVORITE
}
