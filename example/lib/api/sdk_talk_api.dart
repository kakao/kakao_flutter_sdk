import 'package:example/model/custom_data.dart';
import 'package:example/model/friend_page_item.dart';
import 'package:example/model/list_item.dart';
import 'package:example/util/log.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'sdk_message_templates.dart';

const _tag = 'TalkApi';

Function(Friends?, Object?)? recursiveAppFriendsCallback;

List<ListItem> createTalkApis(CustomData customData) => <ListItem>[
  const Header(_tag),
  Api('profile()', (context) async {
    // 카카오톡 프로필 받기

    try {
      final TalkProfile profile = await TalkApi.instance.profile();
      Log.i(
        _tag,
        '카카오톡 프로필 받기 성공\n닉네임: ${profile.nickname}\n프로필사진: ${profile.thumbnailUrl}\n국가코드: ${profile.countryISO}',
      );
    } catch (e) {
      Log.e(_tag, '카카오톡 프로필 받기 실패', e);
    }
  }),
  Api('sendCustomMemo()', (context) async {
    // 커스텀 템플릿으로 나에게 보내기

    // 메시지 템플릿 아이디
    // * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
    final int templateId = customData.templateId;

    try {
      await TalkApi.instance.sendCustomMemo(templateId: templateId);
      Log.i(_tag, '나에게 보내기 성공');
    } catch (e) {
      Log.e(_tag, '나에게 보내기 실패', e);
    }
  }),
  Api('sendDefaultMemo() - feed', (context) async {
    // 디폴트 템플릿으로 나에게 보내기 - Feed

    try {
      await TalkApi.instance.sendDefaultMemo(defaultFeed);
      Log.i(_tag, '나에게 보내기 성공');
    } catch (e) {
      Log.e(_tag, '나에게 보내기 실패', e);
    }
  }),
  Api('sendScrapMemo()', (context) async {
    // 스크랩 템플릿으로 나에게 보내기

    // 공유할 웹페이지 URL
    //  * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
    final String url = 'https://developers.kakao.com';

    try {
      await TalkApi.instance.sendScrapMemo(url: url);
      Log.i(_tag, '나에게 보내기 성공');
    } catch (e) {
      Log.e(_tag, '나에게 보내기 실패', e);
    }
  }),
  Api('friends()', (context) async {
    // 카카오톡 친구 목록 받기 (기본)

    try {
      final Friends friends = await TalkApi.instance.friends(
        offset: 0,
        limit: 5,
        order: Order.desc,
        friendOrder: FriendOrder.nickname,
      );
      Log.i(
        _tag,
        '카카오톡 친구 목록 받기 성공\n${friends.elements?.map((e) => e.profileNickname).join('\n')}',
      );

      // 친구의 UUID 로 메시지 보내기 가능
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
    }
  }),
  Api('friends(order: Order.desc)', (context) async {
    // 카카오톡 친구 목록 받기 (파라미터)

    try {
      // 내림차순으로 받기
      final Friends friends = await TalkApi.instance.friends(order: Order.desc);
      Log.i(
        _tag,
        '카카오톡 친구 목록 받기 성공\n${friends.elements?.map((e) => e.profileNickname).join('\n')}',
      );

      // 친구의 UUID 로 메시지 보내기 가능
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
    }
  }),
  Api('friends(context) - recursive', showResult: false, (context) async {
    var nextFriendsContext = FriendsContext(
      offset: 0,
      limit: 3,
      order: Order.desc,
    );

    recursiveAppFriendsCallback = (nextFriends, error) async {
      if (error != null) {
        Log.e(_tag, '카카오톡 친구 목록 받기 실패', error);
        return;
      }

      if (nextFriends != null) {
        if (nextFriends.afterUrl == null) {
          Log.i(_tag, '카카오톡 친구 목록 없음');
          return;
        }

        nextFriendsContext = FriendsContext.fromUrl(
          Uri.parse(nextFriends.afterUrl!),
        );
      }

      try {
        final Friends friends = await TalkApi.instance.friends(
          context: nextFriendsContext,
        );
        Log.i(
          _tag,
          '카카오톡 친구 목록 받기 성공\n${friends.elements?.map((e) => e.profileNickname).join('\n')}',
        );
        recursiveAppFriendsCallback?.call(friends, null);
      } catch (e) {
        Log.e(_tag, '카카오톡 친구 목록 받기 실패 $e');
        return;
      }
    };

    recursiveAppFriendsCallback?.call(null, null);
  }),
  Api('friends(context) - FriendContext', (context) async {
    try {
      final Friends friends = await TalkApi.instance.friends(
        context: FriendsContext(offset: 0, limit: 1, order: Order.desc),
      );
      Log.i(_tag, '카카오톡 친구 목록 받기 성공\n${friends.elements?.join('\n')}');
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
    }
  }),
  Api('sendCustomMessage()', (context) async {
    // 커스텀 템플릿으로 친구에게 메시지 보내기

    // 카카오톡 친구 목록 받기
    Friends friends;
    try {
      friends = await TalkApi.instance.friends();
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
      return;
    }
    if (!context.mounted) return;

    if (friends.elements == null) {
      return;
    }

    if (friends.elements!.isEmpty) {
      Log.e(_tag, '메시지 보낼 친구가 없습니다');
    } else {
      final items = friends.elements!
          .map(
            (friend) => FriendPageItem(
              friend.uuid,
              friend.profileNickname ?? '',
              friend.profileThumbnailImage,
            ),
          )
          .toList();

      // 서비스의 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
      // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
      final List<String>? selectedItems = await context.push(
        '/friend',
        extra: items,
      );
      if (!context.mounted) return;

      Log.i(_tag, '선택된 친구:\n${selectedItems?.join('\n')}');

      if (selectedItems == null || selectedItems.isEmpty) {
        return;
      }

      // 메시지 보낼 친구의 UUID 목록
      final List<String> receiverUuids = selectedItems;

      // 메시지 템플릿 아이디
      // * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
      final int templateId = customData.templateId;

      // 메시지 보내기
      try {
        final MessageSendResult result = await TalkApi.instance
            .sendCustomMessage(
              receiverUuids: receiverUuids,
              templateId: templateId,
            );
        Log.i(_tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

        if (result.failureInfos != null) {
          Log.i(
            _tag,
            '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}',
          );
        }
      } catch (e) {
        Log.e(_tag, '메시지 보내기 실패', e);
      }
    }
  }),
  Api('sendDefaultMessage() - feed', (context) async {
    // 디폴트 템플릿으로 친구에게 메시지 보내기 - Feed

    // 카카오톡 친구 목록 받기
    Friends friends;
    try {
      friends = await TalkApi.instance.friends();
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
      return;
    }
    if (!context.mounted) return;

    if (friends.elements == null) {
      return;
    }

    if (friends.elements!.isEmpty) {
      Log.e(_tag, '메시지 보낼 친구가 없습니다');
    } else {
      final items = friends.elements!
          .map(
            (friend) => FriendPageItem(
              friend.uuid,
              friend.profileNickname ?? '',
              friend.profileThumbnailImage,
            ),
          )
          .toList();

      // 서비스의 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
      // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.

      final List<String>? selectedItems = await context.push(
        '/friend',
        extra: items,
      );
      if (!context.mounted) return;

      Log.i(_tag, '선택된 친구:\n${selectedItems?.join('\n')}');

      if (selectedItems == null || selectedItems.isEmpty) {
        return;
      }

      // 메시지 보낼 친구의 UUID 목록
      final List<String> receiverUuids = selectedItems;

      // Feed 메시지
      final FeedTemplate template = defaultFeed;

      // 메시지 보내기
      try {
        final MessageSendResult result = await TalkApi.instance
            .sendDefaultMessage(
              receiverUuids: receiverUuids,
              template: template,
            );
        Log.i(_tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

        if (result.failureInfos != null) {
          Log.i(
            _tag,
            '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}',
          );
        }
      } catch (e) {
        Log.e(_tag, '메시지 보내기 실패', e);
      }
    }
  }),
  Api('sendDefaultMessage() - calendar', (context) async {
    // 디폴트 템플릿으로 친구에게 메시지 보내기 - calendar

    // 카카오톡 친구 목록 받기
    Friends friends;
    try {
      friends = await TalkApi.instance.friends();
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
      return;
    }
    if (!context.mounted) return;

    if (friends.elements == null) {
      return;
    }

    if (friends.elements!.isEmpty) {
      Log.e(_tag, '메시지 보낼 친구가 없습니다');
    } else {
      final items = friends.elements!
          .map(
            (friend) => FriendPageItem(
              friend.uuid,
              friend.profileNickname ?? '',
              friend.profileThumbnailImage,
            ),
          )
          .toList();

      // 서비스의 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
      // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
      final List<String>? selectedItems = await context.push(
        '/friend',
        extra: items,
      );
      if (!context.mounted) return;

      Log.i(_tag, '선택된 친구:\n${selectedItems?.join('\n')}');

      if (selectedItems == null || selectedItems.isEmpty) {
        return;
      }

      // 메시지 보낼 친구의 UUID 목록
      final List<String> receiverUuids = selectedItems;

      final String calendarId = customData.calendarEventId;
      // Calendar 메시지
      CalendarTemplate template = defaultCalendar(calendarId);

      // 메시지 보내기
      try {
        final MessageSendResult result = await TalkApi.instance
            .sendDefaultMessage(
              receiverUuids: receiverUuids,
              template: template,
            );
        Log.i(_tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

        if (result.failureInfos != null) {
          Log.i(
            _tag,
            '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}',
          );
        }
      } catch (e) {
        Log.e(_tag, '메시지 보내기 실패', e);
      }
    }
  }),
  Api('sendScrapMessage() - first friend', (context) async {
    // 스크랩 템플릿으로 친구에게 메시지 보내기

    // 카카오톡 친구 목록 받기
    Friends friends;
    try {
      friends = await TalkApi.instance.friends();
    } catch (e) {
      Log.e(_tag, '카카오톡 친구 목록 받기 실패', e);
      return;
    }
    if (!context.mounted) return;

    if (friends.elements == null) {
      return;
    }

    if (friends.elements!.isEmpty) {
      Log.e(_tag, '메시지 보낼 친구가 없습니다');
    } else {
      final items = friends.elements!
          .map(
            (friend) => FriendPageItem(
              friend.uuid,
              friend.profileNickname ?? '',
              friend.profileThumbnailImage,
            ),
          )
          .toList();

      // 서비스의 상황에 맞게 메시지 보낼 친구의 UUID 를 가져오세요.
      // 이 샘플에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID 를 수집하도록 구현했습니다.
      final List<String>? selectedItems = await context.push(
        '/friend',
        extra: items,
      );
      if (!context.mounted) return;

      Log.i(_tag, '선택된 친구:\n${selectedItems?.join('\n')}');

      if (selectedItems == null || selectedItems.isEmpty) {
        return;
      }

      // 메시지 보낼 친구의 UUID 목록
      final List<String> receiverUuids = selectedItems;

      // 공유할 웹페이지 URL
      //  * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
      final String url = "https://developers.kakao.com";

      // 메시지 보내기
      try {
        final MessageSendResult result = await TalkApi.instance
            .sendScrapMessage(receiverUuids: receiverUuids, url: url);
        Log.i(_tag, '메시지 보내기 성공 ${result.successfulReceiverUuids}');

        if (result.failureInfos != null) {
          Log.i(
            _tag,
            '메시지 보내기에 일부 성공했으나, 일부 대상에게는 실패 \n${result.failureInfos}',
          );
        }
      } catch (e) {
        Log.e(_tag, '메시지 보내기 실패', e);
      }
    }
  }),
  Api('channels()', (context) async {
    // 카카오톡 채널 관계 조회

    try {
      final String channelId = customData.channelId;

      final Channels relations = await TalkApi.instance.channels([channelId]);
      Log.i(_tag, '채널 관계 조회 성공\n${relations.channels}');
    } catch (e) {
      Log.e(_tag, '채널 관계 조회 실패', e);
    }
  }),
  Api('followChannel()', (context) async {
    final String channelId = customData.channelId;

    try {
      final result = await TalkApi.instance.followChannel(channelId);
      Log.i(_tag, '채널 추가 성공 $result');
    } catch (e) {
      Log.e(_tag, '채널 추가 실패', e);
    }
  }),
  Api('addChannel()', showResult: false, (context) async {
    final String channelId = customData.channelId;

    // 카카오톡 채널 추가 화면 열기
    await TalkApi.instance.addChannel(channelId);
  }),
  Api('chatChannel()', showResult: false, (context) async {
    final String channelId = customData.channelId;

    try {
      // 카카오톡 채널 채팅
      await TalkApi.instance.chatChannel(channelId);
    } catch (e) {
      Log.e(_tag, '채널 채팅 실패', e);
    }
  }),
  Api('addChannelUrl()', (context) async {
    final String channelId = customData.channelId;
    final Uri url = TalkApi.instance.addChannelUrl(channelId);

    Log.i(_tag, '채널 추가 URL\n$url');
    await launchBrowser(url);
  }),
  Api('chatChannelUrl()', (context) async {
    final String channelId = customData.channelId;
    final Uri url = TalkApi.instance.chatChannelUrl(channelId);

    Log.i(_tag, '채널 채팅 URL\n$url');
    await launchBrowser(url);
  }),
];
