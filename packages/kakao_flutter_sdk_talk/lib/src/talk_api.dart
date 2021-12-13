import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/auth.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channels.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friends.dart';
import 'package:kakao_flutter_sdk_talk/src/model/message_send_result.dart';
import 'package:kakao_flutter_sdk_talk/src/model/talk_profile.dart';
import 'package:kakao_flutter_sdk_template/template.dart';

/// 카카오톡 API 호출을 담당하는 클라이언트.
class TalkApi {
  TalkApi(this._dio);

  final Dio _dio;

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final TalkApi instance = TalkApi(AuthApiFactory.authApi);

  /// 카카오톡 프로필 가져오기.
  Future<TalkProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/api/talk/profile",
          queryParameters: {"secure_resource": true});
      return TalkProfile.fromJson(response.data);
    });
  }

  /// 카카오 디벨로퍼스에서 생성한 서비스만의 커스텀 메시지 템플릿을 사용하여, 카카오톡의 나와의 채팅방으로 메시지 전송.
  ///
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고.
  Future<void> customMemo(int templateId,
      {Map<String, String>? templateArgs}) async {
    final params = {
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _memo("", params);
  }

  /// 기본 템플릿을 이용하여, 카카오톡의 나와의 채팅방으로 메시지 전송.
  Future<void> defaultMemo(DefaultTemplate template) async {
    return _memo("default/", {"template_object": jsonEncode(template)});
  }

  /// 지정된 URL 을 스크랩하여, 카카오톡의 나와의 채팅방으로 메시지 전송.
  Future<void> scrapMemo(String url,
      {int? templateId, Map<String, String>? templateArgs}) async {
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

  /// 사용자가 특정 카카오톡 채널을 추가했는지 확인.
  Future<Channels> plusFriends([List<String>? publicIds]) async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get("/v1/api/talk/channels",
          queryParameters: publicIds == null
              ? {}
              : {"channel_public_ids": jsonEncode(publicIds)});
      return Channels.fromJson(response.data);
    });
  }

  /// 카카오톡 친구 목록 가져오기.
  Future<Friends> friends(
      {int? offset,
      int? limit,
      FriendOrder? friendOrder,
      String? order}) async {
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
      return Friends.fromJson(response.data);
    });
  }

  /// 카카오 디벨로퍼스에서 생성한 서비스만의 커스텀 메시지 템플릿을 사용하여, 카카오톡의 나와의 채팅방으로 메시지 전송.
  ///
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고.
  Future<MessageSendResult> customMessage(
      List<String> receiverUuids, int templateId,
      {Map<String, String>? templateArgs}) async {
    final params = {
      "receiver_uuids": jsonEncode(receiverUuids),
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _message("", params);
  }

  /// 기본 템플릿을 이용하여, 카카오톡의 나와의 채팅방으로 메시지 전송.
  Future<MessageSendResult> defaultMessage(
      List<String> receiverUuids, DefaultTemplate template) async {
    final params = {
      "receiver_uuids": jsonEncode(receiverUuids),
      "template_object": jsonEncode(template)
    };
    return _message("default/", params);
  }

  /// 지정된 URL 을 스크랩하여, 카카오톡의 나와의 채팅방으로 메시지 전송.
  Future<MessageSendResult> scrapMessage(List<String> receiverUuids, String url,
      {int? templateId, Map<String, String>? templateArgs}) async {
    final params = {
      "receiver_uuids": jsonEncode(receiverUuids),
      "request_url": url,
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _message("scrap/", params);
  }

  /// 카카오톡 채널을 추가하기 위한 URL 반환. URL 을 브라우저나 웹뷰에서 로드하면 브릿지 웹페이지를 통해 카카오톡 실행.
  ///
  /// [channelId]는 카카오톡 채널 홈 URL 에 들어간 {_영문}으로 구성된 고유 아이디.
  /// 홈 URL 은 카카오톡 채널 관리자센터 > 관리 > 상세설정 페이지에서 확인.
  ///
  Future<Uri> channelAddUrl(final String channelId) async {
    return Uri(
        scheme: "https",
        host: KakaoSdk.hosts.pf,
        path: "/$channelId/friend",
        queryParameters: await _channelBaseParams());
  }

  /// 카카오톡 채널 1:1 대화방 실행을 위한 URL 반환. URL 을 브라우저나 웹뷰에서 로드하면 브릿지 웹페이지를 통해 카카오톡 실행.
  ///
  /// [channelId]는 카카오톡 채널 홈 URL 에 들어간 {_영문}으로 구성된 고유 아이디.
  /// 홈 URL 은 카카오톡 채널 관리자센터 > 관리 > 상세설정 페이지에서 확인.
  Future<Uri> channelChatUrl(final String channelId) async {
    return Uri(
        scheme: "https",
        host: KakaoSdk.hosts.pf,
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
      "app_key": KakaoSdk.nativeKey,
      "kakao_agent": await KakaoSdk.kaHeader,
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
