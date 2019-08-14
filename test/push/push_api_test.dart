import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/push.dart';
import 'package:platform/platform.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  MockAdapter _adapter;
  PushApi _api;
  Dio _dio;

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _api = PushApi(_dio, FakePlatform(operatingSystem: "android"));
  });

  tearDown(() {});

  group("/v1/push/register", () {
    test("200", () async {
      _adapter.setResponseString("30", 200);
      final expiresIn = await _api.register(1, "device_id", "push_token");
      expect(expiresIn, 30);
    });

    test("on windows", () async {
      _api = PushApi(_dio, FakePlatform(operatingSystem: "windows"));
      try {
        await _api.register(1, "device_id", "push_token");
        fail("should not reach here");
      } catch (e) {
        expect(e, isInstanceOf<KakaoClientException>());
      }
    });
  });

  group("/v1/push/deregister", () {
    test("200", () async {
      _adapter.setResponseString("", 200);
      await _api.deregister(1, "device_id");
    });
  });

  group("/v1/push/tokens", () {
    test("200 with 1 token", () async {
      final body = await loadJson("push/tokens.json");
      _adapter.setResponseString(body, 200);
      final array = jsonDecode(body);
      final tokens = await _api.tokens(1);
      expect(tokens.length, 1);
      final token = tokens[0];
      final expected = array[0];
      expect(token.deviceId, expected["device_id"]);
      expect(token.pushType, PushType.GCM);
      expect(token.pushToken, expected["push_token"]);
      expect(
          Util.dateTimeWithoutMillis(token.createdAt), expected["created_at"]);
      expect(
          Util.dateTimeWithoutMillis(token.updatedAt), expected["updated_at"]);
      expect(token.toJson() != null, true);
    });
  });
}
