import 'dart:convert';

import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'constants.dart';
import 'model/channels.dart';
import 'model/follow_channel_result.dart';
import 'model/friend.dart';
import 'model/friends.dart';
import 'model/message_send_result.dart';
import 'model/talk_profile.dart';
import 'talk_platform.dart';

/// KO: 카카오톡 채널, 카카오톡 소셜, 카카오톡 메시지 API 클라이언트
/// <br>
/// EN: Client for the Kakao Talk Channel, Kakao Talk Social, Kakao Talk Message APIs
class TalkApi {
  /// @nodoc
  TalkApi({KakaoHttpClient? client, TalkPlatform? platform})
    : _client = client ?? KakaoAuthHttpClientFactory.authApi,
      _platform = platform ?? TalkPlatform.instance;

  final KakaoHttpClient _client;
  final TalkPlatform _platform;

  static final TalkApi instance = TalkApi();

  /// KO: 카카오톡 프로필 조회
  /// <br>
  /// EN: Retrieve Kakao Talk profile
  Future<TalkProfile> profile() async {
    SdkLog.d('[TalkApi.profile] started');
    final params = <String, String>{Constants.secureResource: true.toString()};
    final response = await _client.get(
      Constants.profilePath,
      queryParameters: params,
    );
    final result = TalkProfile.fromJson(response.data);
    SdkLog.i('[TalkApi.profile] completed');
    return result;
  }

  /// KO: 나에게 사용자 정의 템플릿으로 메시지 발송<br>
  /// [templateId]에 메시지 템플릿 ID 전달<br>
  /// <br>
  /// EN: Send message with custom template to me<br>
  /// Pass the message template ID to [templateId]
  Future<void> sendCustomMemo({
    required int templateId,
    Map<String, String>? templateArgs,
  }) {
    SdkLog.d(
      '[TalkApi.sendCustomMemo] started | templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0}',
    );
    return _sendMemo(
      pathPart: '',
      params: {
        Constants.templateId: templateId,
        Constants.templateArgs: ?templateArgs?.toJson(),
      },
    );
  }

  /// KO: 나에게 기본 템플릿으로 메시지 발송<br>
  /// [template]에 메시지 템플릿 객체 전달<br>
  /// <br>
  /// EN: Send message with default template to me<br>
  /// Pass an object of a message template to [template]
  Future<void> sendDefaultMemo(DefaultTemplate template) {
    SdkLog.d(
      '[TalkApi.sendDefaultMemo] started | templateType=${template.runtimeType}',
    );
    return _sendMemo(
      pathPart: Constants.defaultPath,
      params: {Constants.templateObject: jsonEncode(template)},
    );
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
  }) {
    SdkLog.d(
      '[TalkApi.sendScrapMemo] started | url=$url templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0}',
    );
    return _sendMemo(
      pathPart: Constants.scrapPath,
      params: {
        Constants.requestUrl: url,
        Constants.templateId: ?templateId,
        Constants.templateArgs: ?templateArgs?.toJson(),
      },
    );
  }

  /// KO: 카카오톡 채널 관계 조회<br>
  /// [publicIds]에 카카오톡 채널 프로필 ID 목록 전달<br>
  /// <br>
  /// EN: Check Kakao Talk Channel relationship<br>
  /// Pass a list of Kakao Talk Channel profile IDs to [publicIds]
  Future<Channels> channels([List<String>? publicIds]) async {
    SdkLog.d(
      '[TalkApi.channels] started | publicIdCount=${publicIds?.length ?? 0}',
    );
    final params = <String, String>{
      Constants.channelIds: ?publicIds?.join(','),
      Constants.channelIdType: Constants.channelPublicId,
    };
    final response = await _client.get(
      Constants.v2ChannelsPath,
      queryParameters: params,
    );
    final result = Channels.fromJson(response.data);
    SdkLog.i(
      '[TalkApi.channels] completed | channelCount=${result.channels?.length ?? 0}',
    );
    return result;
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
    SdkLog.d(
      '[TalkApi.friends] started | offset=${context?.offset ?? offset} limit=${context?.limit ?? limit} friendOrder=${context?.friendOrder?.name ?? friendOrder?.name} order=${context?.order?.name ?? order?.name}',
    );
    final params = <String, Object>{
      Constants.offset: ?(context?.offset ?? offset),
      Constants.limit: ?(context?.limit ?? limit),
      Constants.friendOrder: ?(context?.friendOrder?.name ?? friendOrder?.name),
      Constants.order: ?(context?.order?.name ?? order?.name),
      Constants.secureResource: true.toString(),
    };
    final response = await _client.get(
      Constants.v1FriendsPath,
      queryParameters: params,
    );
    final result = Friends.fromJson(response.data);
    SdkLog.i(
      '[TalkApi.friends] completed | friendCount=${result.elements?.length ?? 0} afterUrl=${result.afterUrl}',
    );
    return result;
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
  }) {
    SdkLog.d(
      '[TalkApi.sendCustomMessage] started | receiverCount=${receiverUuids.length} templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0}',
    );
    return _sendMessage(
      pathPart: '',
      params: {
        Constants.receiverUuids: jsonEncode(receiverUuids),
        Constants.templateId: templateId,
        Constants.templateArgs: ?templateArgs?.toJson(),
      },
    );
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
  }) {
    SdkLog.d(
      '[TalkApi.sendDefaultMessage] started | receiverCount=${receiverUuids.length} templateType=${template.runtimeType}',
    );
    return _sendMessage(
      pathPart: Constants.defaultPath,
      params: {
        Constants.receiverUuids: jsonEncode(receiverUuids),
        Constants.templateObject: jsonEncode(template),
      },
    );
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
  }) {
    SdkLog.d(
      '[TalkApi.sendScrapMessage] started | receiverCount=${receiverUuids.length} url=$url templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0}',
    );
    return _sendMessage(
      pathPart: Constants.scrapPath,
      params: {
        Constants.receiverUuids: jsonEncode(receiverUuids),
        Constants.requestUrl: url,
        Constants.templateId: ?templateId,
        Constants.templateArgs: ?templateArgs?.toJson(),
      },
    );
  }

  /// KO: 카카오톡 채널 간편 추가
  /// <br>
  /// EN: Follow Kakao Talk Channel
  Future<FollowChannelResult> followChannel(String channelPublicId) async {
    SdkLog.d(
      '[TalkApi.followChannel] started | channelPublicId=$channelPublicId',
    );
    final result = await _platform.followChannel(channelPublicId);
    SdkLog.i('[TalkApi.followChannel] completed');
    return result;
  }

  /// KO: 카카오톡 채널 친구 추가<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Add Kakao Talk Channel<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Future<void> addChannel(String channelPublicId) async {
    SdkLog.d('[TalkApi.addChannel] started | channelPublicId=$channelPublicId');
    await _platform.addChannel(channelPublicId);
    SdkLog.i('[TalkApi.addChannel] completed');
  }

  /// KO: 카카오톡 채널 채팅<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Start Kakao Talk Channel chat<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Future<void> chatChannel(String channelPublicId) {
    SdkLog.d(
      '[TalkApi.chatChannel] started | channelPublicId=$channelPublicId',
    );
    return _platform.chatChannel(channelPublicId);
  }

  /// KO: 카카오톡 채널 추가 페이지 URL 반환<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Returns a URL to add a Kakao Talk Channel as a friend<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Uri addChannelUrl(String channelPublicId) {
    return Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.pf,
      path: '$channelPublicId/${Constants.friend}',
      query: _platform.channelBaseParams().toQuery(),
    );
  }

  /// KO: 카카오톡 채널 채팅 페이지 URL 반환<br>
  /// [channelPublicId]에 카카오톡 채널 프로필 ID 전달<br>
  /// <br>
  /// EN: Returns a URL to start a chat with a Kakao Talk Channel<br>
  /// Pass Kakao Talk Channel profile ID to [channelPublicId]
  Uri chatChannelUrl(String channelPublicId) {
    return Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.pf,
      path: '$channelPublicId/${Constants.chat}',
      query: _platform.channelBaseParams().toQuery(),
    );
  }

  Future<void> _sendMemo({
    required String pathPart,
    required Map<String, Object> params,
  }) {
    SdkLog.v(
      '[TalkApi.sendMemo] started | pathPart=${pathPart.isEmpty ? 'custom' : pathPart}',
    );
    return _client.post(
      '${Constants.v2MemoPath}$pathPart${Constants.send}',
      data: params,
    );
  }

  Future<MessageSendResult> _sendMessage({
    required String pathPart,
    required Map<String, Object> params,
  }) async {
    SdkLog.v(
      '[TalkApi.sendMessage] started | pathPart=${pathPart.isEmpty ? 'custom' : pathPart}',
    );
    final response = await _client.post(
      '${Constants.v1OpenTalkMessagePath}$pathPart${Constants.send}',
      data: params,
    );
    final result = MessageSendResult.fromJson(response.data);
    SdkLog.i(
      '[TalkApi.sendMessage] completed | successReceiverCount=${result.successfulReceiverUuids?.length ?? 0} failureInfoCount=${result.failureInfos?.length ?? 0}',
    );
    return result;
  }
}
