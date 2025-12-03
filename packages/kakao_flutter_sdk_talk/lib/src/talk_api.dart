import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/channels.dart';
import 'package:kakao_flutter_sdk_talk/src/model/follow_channel_result.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friend.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friends.dart';
import 'package:kakao_flutter_sdk_talk/src/model/message_send_result.dart';
import 'package:kakao_flutter_sdk_talk/src/model/talk_profile.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// KO: 카카오톡 채널, 카카오톡 소셜, 카카오톡 메시지 API 클라이언트
/// <br>
/// EN: Client for the Kakao Talk Channel, Kakao Talk Social, Kakao Talk Message APIs
class TalkApi {
  final Dio _dio;

  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  static final TalkApi instance = TalkApi(AuthApiFactory.authApi);

  /// @nodoc
  TalkApi(this._dio);

  /// KO: 카카오톡 프로필 조회
  /// <br>
  /// EN: Retrieve Kakao Talk profile
  Future<TalkProfile> profile() async {
    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(Constants.profilePath,
          queryParameters: {Constants.secureResource: true});
      return TalkProfile.fromJson(response.data);
    });
  }

  /// KO: 나에게 사용자 정의 템플릿으로 메시지 발송<br>
  /// [templateId]에 메시지 템플릿 ID 전달<br>
  /// <br>
  /// EN: Send message with custom template to me<br>
  /// Pass the message template ID to [templateId]
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

  /// KO: 나에게 기본 템플릿으로 메시지 발송<br>
  /// [template]에 메시지 템플릿 객체 전달<br>
  /// <br>
  /// EN: Send message with default template to me<br>
  /// Pass an object of a message template to [template]
  Future<void> sendDefaultMemo(DefaultTemplate template) async {
    return _memo(Constants.defaultPath,
        {Constants.templateObject: jsonEncode(template)});
  }

  /// KO: 나에게 스크랩 메시지 발송<br>
  /// [url]에 스크랩할 URL 전달<br>
  /// [templateId]에 메시지 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 전달<br>
  /// <br>
  /// EN: Send scrape message to me<br>
  /// Pass the URL to scrape to [url]<br>
  /// Pass the message template ID to [templateId]<br>
  /// Pass the user arguments to [templateArgs]
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

  /// KO: 카카오톡 채널 관계 조회<br>
  /// [publicIds]에 카카오톡 채널 프로필 ID 목록 전달<br>
  /// <br>
  /// EN: Check Kakao Talk Channel relationship<br>
  /// Pass a list of Kakao Talk Channel profile IDs to [publicIds]
  Future<Channels> channels([List<String>? publicIds]) async {
    var queryParameters = {
      Constants.channelIds: publicIds?.join(','),
      Constants.channelIdType: Constants.channelPublicId,
    };
    queryParameters.removeWhere((k, v) => v == null);

    return ApiFactory.handleApiError(() async {
      Response response = await _dio.get(
        Constants.v2ChannelsPath,
        queryParameters: queryParameters,
      );
      return Channels.fromJson(response.data);
    });
  }

  /// KO: 카카오톡 친구 목록 조회<br>
  /// [offset]으로 친구 목록 시작 지점 변경<br>
  /// [limit]로 페이지당 결과 수 변경<br>
  /// [friendOrder]로 정렬 방식 변경<br>
  /// [order]로 정렬 방식 변경<br>
  /// [context]로 친구 목록 조회 설정<br>
  /// <br>
  /// EN: Retrieve list of friends<br>
  /// Change the start point of the friend list with [offset]<br>
  /// Change the number of results in a page with [limit]<br>
  /// Change the method to sort the friend list with [friendOrder]<br>
  /// Change the sorting method with [order]<br>
  /// Set Context for retrieving friend list with [context]
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
            ? context.friendOrder!.name
            : (friendOrder?.name),
        Constants.order: context != null && context.order != null
            ? context.order!.name
            : (order?.name),
        Constants.secureResource: true
      };
      params.removeWhere((k, v) => v == null);
      final response =
          await _dio.get(Constants.v1FriendsPath, queryParameters: params);
      return Friends.fromJson(response.data);
    });
  }

  /// KO: 친구에게 사용자 정의 템플릿으로 메시지 발송<br>
  /// [receiverUuids]에 수신자 UUID 전달<br>
  /// [templateId]에 메시지 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 전달<br>
  /// <br>
  /// EN: Send message with custom template to friends<br>
  /// Pass the receiver UUIDs to [receiverUuids]<br>
  /// Pass the message template ID to [templateId]<br>
  /// Pass the user arguments to [templateArgs]
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

  /// KO: 친구에게 기본 템플릿으로 메시지 발송<br>
  /// [receiverUuids]에 수신자 UUID 전달<br>
  /// [template]에 메시지 템플릿 객체 전달<br>
  /// <br>
  /// EN: Send message with default template to friends<br>
  /// Pass the receiver UUIDs to [receiverUuids]<br>
  /// Pass an object of a message template to [template]
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

  /// KO: 친구에게 스크랩 메시지 발송<br>
  /// [receiverUuids]에 수신자 UUID 전달<br>
  /// [url]에 스크랩할 URL 전달<br>
  /// [templateId]에 메시지 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 전달<br>
  /// <br>
  /// EN: Send scrape message to friends<br>
  /// Pass the receiver UUIDs to [receiverUuids]<br>
  /// Pass the URL to scrap to [url]<br>
  /// Pass the message template ID to [templateId]<br>
  /// Pass the user arguments to [templateArgs]
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

  /// KO: 카카오톡 채널 간편 추가
  /// <br>
  /// EN: Follow Kakao Talk Channel
  Future<FollowChannelResult> followChannel(
    final String channelPublicId,
  ) async {
    if (!await AuthApi.instance.hasToken()) {
      return _followChannel(channelPublicId, null);
    }

    String? agt;
    try {
      if (!kIsWeb) {
        await AuthApi.instance.refreshToken();
      }
      agt = await AuthApi.instance.agt();
      return await _followChannel(channelPublicId, agt);
    } catch (e) {
      rethrow;
    }
  }

  /// KO: 카카오톡 채널 친구 추가<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Add Kakao Talk Channel<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Future addChannel(final String channelPublicId) async {
    if (!await isKakaoTalkInstalled()) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        "KakaoTalk is not installed",
      );
    }

    final scheme = isAndroid()
        ? KakaoSdk.platforms.android.talkChannelScheme
        : KakaoSdk.platforms.ios.talkChannelScheme;

    if (!kIsWeb || isMobileWeb()) {
      await _validate('/sdk/channel/add', channelPublicId);
    }

    await _channel.invokeMethod('addChannel', {
      'channel_scheme': scheme,
      'channel_public_id': channelPublicId,
    });
  }

  /// KO: 카카오톡 채널 채팅<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Start Kakao Talk Channel chat<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Future chatChannel(final String channelPublicId) async {
    if (!await isKakaoTalkInstalled()) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        "KakaoTalk is not installed",
      );
    }

    final scheme = isAndroid()
        ? KakaoSdk.platforms.android.talkChannelScheme
        : KakaoSdk.platforms.ios.talkChannelScheme;

    if (!kIsWeb || isMobileWeb()) {
      await _validate('/sdk/channel/chat', channelPublicId);
    }

    var args = {
      'channel_scheme': scheme,
      'channel_public_id': channelPublicId,
    };

    await _channel.invokeMethod('channelChat', args);
  }

  /// KO: 카카오톡 채널 추가 페이지 URL 반환<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Returns a URL to add a Kakao Talk Channel as a friend<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Future<Uri> addChannelUrl(final String channelPublicId) async {
    return Uri(
        scheme: Constants.scheme,
        host: KakaoSdk.hosts.pf,
        path: "/$channelPublicId/${Constants.friend}",
        queryParameters: await _channelBaseParams());
  }

  /// KO: 카카오톡 채널 채팅 페이지 URL 반환<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Returns a URL to start a chat with a Kakao Talk Channel<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Future<Uri> chatChannelUrl(final String channelPublicId) async {
    return Uri(
        scheme: Constants.scheme,
        host: KakaoSdk.hosts.pf,
        path: "/$channelPublicId/${Constants.chat}",
        queryParameters: await _channelBaseParams());
  }

  @Deprecated('This method is replaced with \'TalkApi#chatChannelUrl\'')
  Future<Uri> channelChatUrl(final String channelPublicId) async {
    return await chatChannelUrl(channelPublicId);
  }

  Future _validate(final String path, final String channelPublicId) async {
    var dio = ApiFactory.appKeyApi;

    return ApiFactory.handleApiError(() async {
      String data =
          'quota_properties=${Uri.encodeComponent('{"uri":"$path","channel_public_id":"$channelPublicId"}')}';
      await dio.post("/v1/app/validate/sdk", data: data);
    });
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
      Constants.appKey: KakaoSdk.appKey,
      Constants.kakaoAgent: await KakaoSdk.kaHeader,
      Constants.apiVersion: Constants.apiVersion_10
    };
  }

  Future<FollowChannelResult> _followChannel(
    final String channelPublicId,
    final String? agt,
  ) async {
    if (kIsWeb) {
      return _followChannelForWeb(channelPublicId, agt);
    }
    return _followChannelForNative(channelPublicId, agt);
  }

  Future<FollowChannelResult> _followChannelForNative(
    final String channelPublicId,
    final String? agt,
  ) async {
    final params = {
      Constants.appKey: KakaoSdk.appKey,
      Constants.channelPublicId: channelPublicId,
      Constants.returnUrl:
          '${KakaoSdk.customScheme}://${Constants.followChannelScheme}',
      Constants.ka: await KakaoSdk.kaHeader,
      Constants.agt: agt,
    };
    params.removeWhere((k, v) => v == null);

    final url = Uri.https(
      KakaoSdk.hosts.apps,
      Constants.followChannelPath,
      params,
    ).toString();
    final result = await _channel
        .invokeMethod(Constants.followChannel, {Constants.url: url});

    final resultUri = Uri.parse(result);

    if (resultUri.queryParameters[Constants.status] ==
        Constants.followChannelStatusError) {
      throw KakaoAppsException.fromJson(resultUri.queryParameters);
    }
    return FollowChannelResult.fromJson(resultUri.queryParameters);
  }

  Future<FollowChannelResult> _followChannelForWeb(
    final String channelPublicId,
    final String? agt,
  ) async {
    final params = {
      'channel_public_id': channelPublicId,
      'trans_id': generateRandomString(60),
      'agt': agt,
    };

    final String response =
        await _channel.invokeMethod('followChannel', params);

    final Map<String, dynamic> result = jsonDecode(response);

    if (result.containsKey('error_code')) {
      throw KakaoAppsException.fromJson(result);
    }
    return FollowChannelResult.fromJson(result);
  }
}
