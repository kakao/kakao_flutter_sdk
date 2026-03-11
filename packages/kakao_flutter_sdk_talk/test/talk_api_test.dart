import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/date_time.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';

void main() {
  late TestKakaoHttpClient client;
  late TalkApi api;

  setUp(() {
    client = TestKakaoHttpClient();
    api = TalkApi(client: client);
  });

  group('/v2/api/talk/memo', () {
    setUp(() async {
      client.enqueueJson({});
    });

    tearDown(() async {});
    test('/custom without args', () async {
      await api.sendCustomMemo(templateId: 1234);
      final request = client.lastRequest;
      expect(request.method, 'POST');
      final params = request.data as Map<String, dynamic>;
      expect(params['template_id'], 1234);
      expect(false, params.containsKey('template_args'));
    });

    test('/custom with args', () async {
      final args = {'key1': 'value1', 'key2': 'value2'};
      await api.sendCustomMemo(templateId: 1234, templateArgs: args);
      final request = client.lastRequest;
      expect(request.method, 'POST');
      final params = request.data as Map<String, dynamic>;
      expect(params['template_id'], 1234);
      expect(params['template_args'], jsonEncode(args));
    });

    group('/default', () {
      test('feed', () async {
        final template = FeedTemplate(
          content: Content(
            title: 'title',
            imageUrl: Uri.parse('https://example.com/image.png'),
            link: Link(webUrl: Uri.parse('https://example.com')),
          ),
          social: Social(
            likeCount: 1,
            commentCount: 2,
            sharedCount: 3,
            viewCount: 4,
            subscriberCount: 10,
          ),
        );

        await api.sendDefaultMemo(template);
        final request = client.lastRequest;
        expect(request.method, 'POST');
        final Map<String, dynamic> params =
            request.data as Map<String, dynamic>;
        expect(true, params.containsKey('template_object'));
        expect(params['template_object'], jsonEncode(template));
      });

      test('commerce', () async {
        final template = CommerceTemplate(
          content: Content(
            title: 'title',
            imageUrl: Uri.parse('https://developers.kakao.com/image.png'),
            link: Link(webUrl: Uri.parse('https://developers.kakao.com')),
          ),
          commerce: Commerce(regularPrice: 15000),
        );

        await api.sendDefaultMemo(template);
        final request = client.lastRequest;
        final params = request.data as Map<String, dynamic>;
        expect(params['template_object'], jsonEncode(template));
      });
    });

    group('/scrap', () {
      test('without args', () async {
        final url = 'https://developers.kakao.com';
        await api.sendScrapMemo(url: url);
        final request = client.lastRequest;
        expect(request.method, 'POST');
        final Map<String, dynamic> params =
            request.data as Map<String, dynamic>;
        expect(params['request_url'], url);
      });

      test('with args', () async {
        final url = 'https://developers.kakao.com';
        final templateId = 1234;
        final args = {'key1': 'value1', 'key2': 'value2'};
        await api.sendScrapMemo(url: url, templateId: 1234, templateArgs: args);
        final request = client.lastRequest;
        expect(request.method, 'POST');
        final Map<String, dynamic> params =
            request.data as Map<String, dynamic>;
        expect(params['request_url'], url);
        expect(params['template_id'], templateId);
        expect(params['template_args'], jsonEncode(args));
      });
    });
  });

  group('v1/api/talk/friends/message/send', () {
    Map<String, dynamic> map;

    test('custom without failure infos', () async {
      final path = uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
      final body = await loadJson('talk/$path/success.json');
      map = jsonDecode(body);
      client.enqueueJson(map);

      final res = await api.sendCustomMessage(
        receiverUuids: ['1234'],
        templateId: 1234,
      );

      final expectedUuids = map['successful_receiver_uuids'];
      final uuids = res.successfulReceiverUuids;
      uuids!.asMap().forEach((idx, uuid) {
        expect(expectedUuids[idx], uuid);
      });
    });

    test('custom with failure infos', () async {
      final path = uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
      final body = await loadJson('talk/$path/partial_success.json');
      map = jsonDecode(body);
      client.enqueueJson(map);

      final res = await api.sendCustomMessage(
        receiverUuids: ['1234'],
        templateId: 1234,
      );

      final expectedInfos = map['failure_info'];
      final infos = res.failureInfos;
      infos?.asMap().forEach((idx, info) {
        expect(expectedInfos[idx]['code'], info.code);
        expect(expectedInfos[idx]['msg'], info.msg);
        expect(expectedInfos[idx]['receiver_uuids'], info.receiverUuids);
      });
    });
  });
  group('/v2/api/talk/channels', () {
    Map<String, dynamic>? map;
    late Channels res;

    setUp(() async {
      final path = uriPathToFilePath(Constants.v2ChannelsPath);
      final body = await loadJson('talk/$path/normal.json');
      map = jsonDecode(body);
      client.enqueueJson(map!);
    });

    tearDown(() async {
      expect(res.userId, map!['user_id']);
      final elements = map!['channels'];
      final friends = res.channels;
      friends?.asMap().forEach((index, friend) {
        final element = elements[index];
        expect(friend.uuid, element['channel_uuid']);
        expect(friend.relation, element['relation']);
        expect(dateTimeWithoutMillis(friend.updatedAt), element['updated_at']);
      });
    });

    test('with no parameter', () async {
      res = await api.channels();
    });

    test('with public ids', () async {
      final publicId = '_frxjem';
      res = await api.channels([publicId]);
      final request = client.lastRequest;
      final params = request.queryParameters!;
      expect(params['channel_ids'], publicId);
    });
  });
}
