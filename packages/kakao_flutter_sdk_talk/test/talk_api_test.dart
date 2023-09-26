import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';

void main() {
  late MockAdapter adapter;
  late TalkApi api;
  late Dio dio;

  setUp(() {
    dio = Dio();
    adapter = MockAdapter();
    dio.httpClientAdapter = adapter;
    api = TalkApi(dio);
  });

  group("/v2/api/talk/memo", () {
    setUp(() async {
      adapter.setResponseString("", 200);
    });

    tearDown(() async {});
    test("/custom without args", () async {
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        Map<String, dynamic> params = options.data;
        expect(params["template_id"], 1234);
        expect(false, params.containsKey("template_args"));
      };
      await api.sendCustomMemo(templateId: 1234);
    });

    test("/custom with args", () async {
      var args = {"key1": "value1", "key2": "value2"};
      adapter.requestAssertions = (RequestOptions options) {
        expect(options.method, "POST");
        var params = options.data;
        expect(params["template_id"], 1234);
        expect(params["template_args"], jsonEncode(args));
      };
      await api.sendCustomMemo(templateId: 1234, templateArgs: args);
    });

    group("/default", () {
      test("feed", () async {
        var template = FeedTemplate(
            content: Content(
              title: "title",
              imageUrl: Uri.parse("https://example.com/image.png"),
              link: Link(
                webUrl: Uri.parse("https://example.com"),
              ),
            ),
            social: Social(
                likeCount: 1,
                commentCount: 2,
                sharedCount: 3,
                viewCount: 4,
                subscriberCount: 10));
        adapter.requestAssertions = (RequestOptions options) {
          expect(options.method, "POST");
          Map<String, dynamic> params = options.data;
          expect(true, params.containsKey("template_object"));
          expect(params["template_object"], jsonEncode(template));
        };

        await api.sendDefaultMemo(template);
      });

      test("commerce", () async {
        var template = CommerceTemplate(
            content: Content(
              title: "title",
              imageUrl: Uri.parse("https://developers.kakao.com/image.png"),
              link: Link(
                webUrl: Uri.parse("https://developers.kakao.com"),
              ),
            ),
            commerce: Commerce(regularPrice: 15000));

        adapter.requestAssertions = (RequestOptions options) {
          expect(options.data["template_object"], jsonEncode(template));
        };
        await api.sendDefaultMemo(template);
      });
    });

    group("/scrap", () {
      test("without args", () async {
        var url = "https://developers.kakao.com";
        adapter.requestAssertions = (RequestOptions options) {
          expect(options.method, "POST");
          Map<String, dynamic> params = options.data;
          expect(params["request_url"], url);
        };
        await api.sendScrapMemo(url: url);
      });

      test("with args", () async {
        var url = "https://developers.kakao.com";
        var templateId = 1234;
        var args = {"key1": "value1", "key2": "value2"};
        adapter.requestAssertions = (RequestOptions options) {
          expect(options.method, "POST");
          Map<String, dynamic> params = options.data;
          expect(params["request_url"], url);
          expect(params["template_id"], templateId);
          expect(params["template_args"], jsonEncode(args));
        };
        await api.sendScrapMemo(url: url, templateId: 1234, templateArgs: args);
      });
    });
  });

  group("v1/api/talk/friends/message/send", () {
    Map<String, dynamic> map;

    test("custom without failure infos", () async {
      final path = uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
      final body = await loadJson("talk/$path/success.json");
      map = jsonDecode(body);
      adapter.setResponseString(body, 200);

      final res = await api.sendCustomMessage(
        receiverUuids: ["1234"],
        templateId: 1234,
      );

      final expectedUuids = map["successful_receiver_uuids"];
      final uuids = res.successfulReceiverUuids;
      uuids!.asMap().forEach((idx, uuid) {
        expect(expectedUuids[idx], uuid);
      });
    });

    test("custom with failure infos", () async {
      final path = uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
      final body = await loadJson("talk/$path/partial_success.json");
      map = jsonDecode(body);
      adapter.setResponseString(body, 200);

      final res = await api.sendCustomMessage(
        receiverUuids: ["1234"],
        templateId: 1234,
      );

      final expectedInfos = map["failure_info"];
      final infos = res.failureInfos;
      infos?.asMap().forEach((idx, info) {
        expect(expectedInfos[idx]["code"], info.code);
        expect(expectedInfos[idx]["msg"], info.msg);
        expect(expectedInfos[idx]["receiver_uuids"], info.receiverUuids);
      });
    });
  });
  group("/v2/api/talk/channels", () {
    Map<String, dynamic>? map;
    late Channels res;

    setUp(() async {
      var path = uriPathToFilePath(Constants.v2ChannelsPath);
      var body = await loadJson("talk/$path/normal.json");
      map = jsonDecode(body);
      adapter.setResponseString(body, 200);
    });

    tearDown(() async {
      expect(res.userId, map!["user_id"]);
      var elements = map!["channels"];
      var friends = res.channels;
      friends?.asMap().forEach((index, friend) {
        var element = elements[index];
        expect(friend.uuid, element["channel_uuid"]);
        expect(friend.relation, element["relation"]);
        expect(
          Util.dateTimeWithoutMillis(friend.updatedAt),
          element["updated_at"],
        );
      });
    });

    test("with no parameter", () async {
      res = await api.channels();
    });

    test("with public ids", () async {
      var publicId = "_frxjem";
      adapter.requestAssertions = (RequestOptions options) {
        var params = options.queryParameters;
        expect(params["channel_ids"], publicId);
      };
      res = await api.channels([publicId]);
    });
  });
}
