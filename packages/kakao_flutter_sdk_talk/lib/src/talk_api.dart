import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channels.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friend.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friends.dart';
import 'package:kakao_flutter_sdk_talk/src/model/message_send_result.dart';
import 'package:kakao_flutter_sdk_talk/src/model/talk_profile.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

/// 카카오톡 API 호출을 담당하는 클라이언트
class TalkApi {
  TalkApi(this._dio);

  final Dio _dio;

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final TalkApi instance = TalkApi(AuthApiFactory.authApi);

  /// 카카오톡 프로필 가져오기
  Future<TalkProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.profilePath,
          queryParameters: {Constants.secureResource: true});
      return TalkProfile.fromJson(response.data);
    });
  }

  /// 카카오 디벨로퍼스에서 생성한 서비스만의 커스텀 메시지 템플릿을 사용하여, 카카오톡의 나와의 채팅방으로 메시지 전송
  ///
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고
  Future<void> sendCustomMemo({
    required int templateId,
    Map<String, String>? templateArgs,
  }) async {
    final params = {
      Constants.templateId: templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _memo("", params);
  }

  /// 기본 템플릿을 이용하여, 카카오톡의 나와의 채팅방으로 메시지 전송
  Future<void> sendDefaultMemo(DefaultTemplate template) async {
    return _memo(Constants.defaultPath,
        {Constants.templateObject: jsonEncode(template)});
  }

  /// 지정된 URL 을 스크랩하여, 카카오톡의 나와의 채팅방으로 메시지 전송
  Future<void> sendScrapMemo({
    required String url,
    int? templateId,
    Map<String, String>? templateArgs,
  }) async {
    final params = {
      Constants.requestUrl: url,
      Constants.templateId: templateId,
      Constants.templateArgs:
          templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _memo(Constants.scrapPath, params);
  }

  Future<void> _memo(String pathPart, Map<String, dynamic> params) async {
    params.removeWhere((k, v) => v == null);
    return ApiFactory.handleApiError(() async {
      await _dio.post("${Constants.v2MemoPath}$pathPart${Constants.send}",
          data: params);
    });
  }

  /// 사용자가 특정 카카오톡 채널을 추가했는지 확인
  Future<Channels> channels([List<String>? publicIds]) async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.v1ChannelsPath,
          queryParameters: publicIds == null
              ? {}
              : {Constants.channelPublicIds: jsonEncode(publicIds)});
      return Channels.fromJson(response.data);
    });
  }

  /// 카카오톡 친구 목록 가져오기
  Future<Friends> friends({
    int? offset,
    int? limit,
    FriendOrder? friendOrder,
    Order? order,
    FriendsContext? context,
  }) async {
    return ApiFactory.handleApiError(() async {
      final params = {
        Constants.offset: context != null ? context.offset : offset,
        Constants.limit: context != null ? context.limit : limit,
        Constants.friendOrder: context != null && context.friendOrder != null
            ? describeEnum(context.friendOrder!)
            : (friendOrder == null ? null : describeEnum(friendOrder)),
        Constants.order: context != null && context.order != null
            ? describeEnum(context.order!)
            : (order == null ? null : describeEnum(order)),
        Constants.secureResource: true
      };
      params.removeWhere((k, v) => v == null);
      final response =
          await _dio.get(Constants.v1FriendsPath, queryParameters: params);
      return Friends.fromJson(response.data);
    });
  }

  /// 카카오 디벨로퍼스에서 생성한 서비스만의 커스텀 메시지 템플릿을 사용하여, 조회한 친구를 대상으로 카카오톡으로 메시지 전송
  ///
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고
  Future<MessageSendResult> sendCustomMessage({
    required List<String> receiverUuids,
    required int templateId,
    Map<String, String>? templateArgs,
  }) async {
    final params = {
      Constants.receiverUuids: jsonEncode(receiverUuids),
      Constants.templateId: templateId,
      Constants.templateArgs:
          templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _message("", params);
  }

  /// 기본 템플릿을 이용하여, 조회한 친구를 대상으로 카카오톡으로 메시지 전송
  Future<MessageSendResult> sendDefaultMessage({
    required List<String> receiverUuids,
    required DefaultTemplate template,
  }) async {
    final params = {
      Constants.receiverUuids: jsonEncode(receiverUuids),
      Constants.templateObject: jsonEncode(template)
    };
    return _message(Constants.defaultPath, params);
  }

  /// 지정된 URL 을 스크랩하여, 조회한 친구를 대상으로 카카오톡으로 메시지 전송
  ///
  /// 스크랩 커스텀 템플릿 가이드를 참고하여 템플릿을 직접 만들고 스크랩 메시지 전송에 이용 가능
  Future<MessageSendResult> sendScrapMessage({
    required List<String> receiverUuids,
    required String url,
    int? templateId,
    Map<String, String>? templateArgs,
  }) async {
    final params = {
      Constants.receiverUuids: jsonEncode(receiverUuids),
      Constants.requestUrl: url,
      Constants.templateId: templateId,
      Constants.templateArgs:
          templateArgs == null ? null : jsonEncode(templateArgs)
    };
    return _message(Constants.scrapPath, params);
  }

  /// 카카오톡 채널을 추가하기 위한 URL 반환. URL 을 브라우저나 웹뷰에서 로드하면 브릿지 웹페이지를 통해 카카오톡 실행
  ///
  /// [channelPublicId]는 카카오톡 채널 홈 URL 에 들어간 {_영문}으로 구성된 고유 아이디
  /// 홈 URL 은 카카오톡 채널 관리자센터 > 관리 > 상세설정 페이지에서 확인
  ///
  Future<Uri> addChannelUrl(final String channelPublicId) async {
    return Uri(
        scheme: Constants.scheme,
        host: KakaoSdk.hosts.pf,
        path: "/$channelPublicId/${Constants.friend}",
        queryParameters: await _channelBaseParams());
  }

  /// 카카오톡 채널 1:1 대화방 실행을 위한 URL 반환. URL 을 브라우저나 웹뷰에서 로드하면 브릿지 웹페이지를 통해 카카오톡 실행
  ///
  /// [channelPublicId]는 카카오톡 채널 홈 URL 에 들어간 {_영문}으로 구성된 고유 아이디
  /// 홈 URL 은 카카오톡 채널 관리자센터 > 관리 > 상세설정 페이지에서 확인
  Future<Uri> channelChatUrl(final String channelPublicId) async {
    return Uri(
        scheme: Constants.scheme,
        host: KakaoSdk.hosts.pf,
        path: "/$channelPublicId/${Constants.chat}",
        queryParameters: await _channelBaseParams());
  }

  Future<MessageSendResult> _message(
    String pathPart,
    Map<String, dynamic> params,
  ) async {
    return ApiFactory.handleApiError(() async {
      params.removeWhere((k, v) => v == null);
      final response = await _dio.post(
          "${Constants.v1OpenTalkMessagePath}$pathPart${Constants.send}",
          data: params);
      return MessageSendResult.fromJson(response.data);
    });
  }

  Future<Map<String, String>> _channelBaseParams() async {
    return {
      Constants.appKey: KakaoSdk.nativeKey,
      Constants.kakaoAgent: await KakaoSdk.kaHeader,
      Constants.apiVersion: Constants.apiVersion_10
    };
  }
}
