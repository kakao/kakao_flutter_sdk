import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/link/link_api.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  MockAdapter _adapter;
  LinkApi _api;
  Dio _dio;
  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _api = LinkApi(_dio);
  });

  test("send custom 200", () async {
    String body = await loadJson("link/validate.json");
    var map = jsonDecode(body);

    _adapter.requestAssertions = (RequestOptions options) {};
    _adapter.setResponseString(body, 200);

    var response = await _api.custom(4718, templateArgs: {"key1": "value1"});
    expect(response.templateId, map["template_id"]);
  });
}
