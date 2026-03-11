import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';
import 'package:kakao_flutter_sdk_talk/src/model/follow_channel_result.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friend.dart';
import 'package:kakao_flutter_sdk_talk/src/talk_api.dart';
import 'package:kakao_flutter_sdk_talk/src/talk_platform.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestKakaoHttpClient client;
  late _FakeTalkPlatform platform;
  late TalkApi api;

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: 'test_app_key',
      platformProvider: FakeCommonPlatform(),
    );
    client = TestKakaoHttpClient();
    platform = _FakeTalkPlatform();
    api = TalkApi(client: client, platform: platform);
  });

  test('profile requests secure resource and parses response', () async {
    final path = uriPathToFilePath(Constants.profilePath);
    final body = await loadJson('talk/$path/normal.json');
    final map = jsonDecode(body);
    client.enqueueJson(map);

    final profile = await api.profile();

    expect(client.lastRequest.path, Constants.profilePath);
    expect(
      client.lastRequest.queryParameters?[Constants.secureResource],
      'true',
    );
    expect(profile.nickname, map['nickName']);
  });

  test('friends uses explicit pagination and sort options', () async {
    final path = uriPathToFilePath(Constants.v1FriendsPath);
    final body = await loadJson('talk/$path/normal.json');
    client.enqueueJson(jsonDecode(body));

    await api.friends(
      offset: 5,
      limit: 20,
      friendOrder: FriendOrder.favorite,
      order: Order.desc,
    );

    final query = client.lastRequest.queryParameters!;
    expect(query[Constants.offset], 5);
    expect(query[Constants.limit], 20);
    expect(query[Constants.friendOrder], FriendOrder.favorite.name);
    expect(query[Constants.order], Order.desc.name);
  });

  test('friends prefers context values over direct arguments', () async {
    final path = uriPathToFilePath(Constants.v1FriendsPath);
    final body = await loadJson('talk/$path/normal.json');
    client.enqueueJson(jsonDecode(body));
    final context = FriendsContext(
      offset: 99,
      limit: 30,
      friendOrder: FriendOrder.nickname,
      order: Order.asc,
    );

    await api.friends(
      offset: 1,
      limit: 2,
      friendOrder: FriendOrder.favorite,
      order: Order.desc,
      context: context,
    );

    final query = client.lastRequest.queryParameters!;
    expect(query[Constants.offset], 99);
    expect(query[Constants.limit], 30);
    expect(query[Constants.friendOrder], FriendOrder.nickname.name);
    expect(query[Constants.order], Order.asc.name);
  });

  test('sendDefaultMessage sends receiverUuids and template JSON', () async {
    final path = uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
    final body = await loadJson('talk/$path/success.json');
    client.enqueueJson(jsonDecode(body));
    final template = TextTemplate(
      text: 'hello',
      link: Link(webUrl: Uri.parse('https://developers.kakao.com')),
    );

    await api.sendDefaultMessage(
      receiverUuids: ['uuid1', 'uuid2'],
      template: template,
    );

    final request = client.lastRequest;
    final data = request.data as Map<String, dynamic>;
    expect(
      request.path,
      '${Constants.v1OpenTalkMessagePath}${Constants.defaultPath}${Constants.send}',
    );
    expect(data[Constants.receiverUuids], '["uuid1","uuid2"]');
    expect(data[Constants.templateObject], jsonEncode(template));
  });

  test('sendScrapMessage sends url, templateId and args', () async {
    final path = uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
    final body = await loadJson('talk/$path/partial_success.json');
    client.enqueueJson(jsonDecode(body));

    final result = await api.sendScrapMessage(
      receiverUuids: ['uuid1'],
      url: 'https://developers.kakao.com',
      templateId: 1234,
      templateArgs: {'k': 'v'},
    );

    final data = client.lastRequest.data as Map<String, dynamic>;
    expect(
      client.lastRequest.path,
      '${Constants.v1OpenTalkMessagePath}${Constants.scrapPath}${Constants.send}',
    );
    expect(data[Constants.receiverUuids], '["uuid1"]');
    expect(data[Constants.requestUrl], 'https://developers.kakao.com');
    expect(data[Constants.templateId], 1234);
    expect(data[Constants.templateArgs], '{"k":"v"}');
    expect(result.failureInfos, isNotNull);
  });

  test('followChannel, addChannel, chatChannel delegate to platform', () async {
    final followResult = await api.followChannel('_abc');
    await api.addChannel('_abc');
    await api.chatChannel('_abc');

    expect(followResult.success, true);
    expect(followResult.channelPublicId, '_abc');
    expect(platform.followedChannelIds, ['_abc']);
    expect(platform.addedChannelIds, ['_abc']);
    expect(platform.chattedChannelIds, ['_abc']);
  });

  test(
    'addChannelUrl and chatChannelUrl include channel base query params',
    () {
      final addUrl = api.addChannelUrl('_abc');
      final chatUrl = api.chatChannelUrl('_abc');

      expect(addUrl.path, '/_abc/${Constants.friend}');
      expect(chatUrl.path, '/_abc/${Constants.chat}');
      expect(addUrl.queryParameters, platform.baseParams);
      expect(chatUrl.queryParameters, platform.baseParams);
    },
  );
}

class _FakeTalkPlatform implements TalkPlatform {
  final List<String> followedChannelIds = [];
  final List<String> addedChannelIds = [];
  final List<String> chattedChannelIds = [];
  final Map<String, String> baseParams = {
    Constants.appKey: 'test_app_key',
    Constants.kakaoAgent: 'ka/test',
    Constants.apiVersion: Constants.apiVersion_10,
  };

  @override
  Future<void> addChannel(String channelPublicId) async {
    addedChannelIds.add(channelPublicId);
  }

  @override
  Future<void> chatChannel(String channelPublicId) async {
    chattedChannelIds.add(channelPublicId);
  }

  @override
  Map<String, String> channelBaseParams() => baseParams;

  @override
  Future<FollowChannelResult> followChannel(String channelPublicId) async {
    followedChannelIds.add(channelPublicId);
    return FollowChannelResult(true, channelPublicId);
  }
}
