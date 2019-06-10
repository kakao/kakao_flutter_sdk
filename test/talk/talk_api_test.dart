import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/talk/model/talk_profile.dart';
import 'package:kakao_flutter_sdk/src/talk/talk_api.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  MockAdapter _adapter;
  TalkApi _talkApi;
  Dio _dio;

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _talkApi = TalkApi(_dio);
  });

  tearDown(() {});

  test("/v1/api/talk/profile 200", () async {
    String body = await loadJson("talk/profile.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponse(ResponseBody.fromString(
        body,
        200,
        DioHttpHeaders.fromMap(
            {HttpHeaders.contentTypeHeader: ContentType.json})));

    TalkProfile profile = await _talkApi.profile();
    expect(map["nickName"], profile.nickname);
    expect(map["profileImageURL"], profile.profileImageUrl);
    expect(map["thumbnailURL"], profile.thumbnailUrl);
    expect(map["countryISO"], profile.countryISO);
  });
}
