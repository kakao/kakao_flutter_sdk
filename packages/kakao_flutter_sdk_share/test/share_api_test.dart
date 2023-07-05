import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';

void main() {
  late MockAdapter adapter;
  late ShareApi api;
  late Dio dio;

  setUp(() {
    dio = Dio();
    adapter = MockAdapter();
    dio.httpClientAdapter = adapter;
    api = ShareApi(dio);
  });

  test("send custom 200", () async {
    final path =
        uriPathToFilePath('${Constants.validatePath}/${Constants.validate}');
    String body = await loadJson("share/$path/normal.json");
    var map = jsonDecode(body);

    adapter.requestAssertions = (RequestOptions options) {};
    adapter.setResponseString(body, 200);

    var response = await api.custom(4718, templateArgs: {"key1": "value1"});
    expect(response.templateId, map["template_id"]);
  });
}
