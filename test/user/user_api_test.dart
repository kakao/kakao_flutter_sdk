import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/user/model/account.dart';
import 'package:kakao_flutter_sdk/src/user/model/user.dart';
import 'package:kakao_flutter_sdk/src/user/user_api.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  Dio _dio;
  MockAdapter _adapter;
  UserApi _userApi;

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _userApi = UserApi(_dio);
  });
  tearDown(() {});

  test('/v2/user/me 200', () async {
    String body = await loadJson("user/me.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponse(ResponseBody.fromString(
        body,
        200,
        DioHttpHeaders.fromMap(
            {HttpHeaders.contentTypeHeader: ContentType.json})));
    User user = await _userApi.me();

    expect(user.id, map["id"]);
    expect(user.hasSignedUp, map["has_signed_up"]);

    Account account = user.kakaoAccount;
    Map<String, dynamic> accountMap = map["kakao_account"];
    expect(account.hasEmail, accountMap["has_email"]);
    expect(account.email, accountMap["email"]);
    expect(account.isEmailVerified, accountMap["is_email_verified"]);
    expect(account.isKakaotalkUser, accountMap["is_kakaotalk_user"]);
    expect(account.hasPhoneNumber, accountMap["has_phone_number"]);
    expect(account.phoneNumber, accountMap["phone_number"]);
  });
}
