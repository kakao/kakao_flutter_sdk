import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_link/src/link_api.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';

void main() {
  late MockAdapter _adapter;
  late LinkApi _api;
  late Dio _dio;

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
