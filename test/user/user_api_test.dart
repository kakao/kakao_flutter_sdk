import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/user/model/account.dart';
import 'package:kakao_flutter_sdk/src/user/model/user.dart';
import 'package:kakao_flutter_sdk/src/user/user_api.dart';
import 'package:kakao_flutter_sdk/story.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  late Dio _dio;
  late MockAdapter _adapter;
  late UserApi _api;

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _api = UserApi(_dio);
  });
  tearDown(() {});

  test('/v2/user/me 200', () async {
    String body = await loadJson("users/me.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponseString(body, 200);
    User user = await _api.me();

    expect(user.id, map["id"]);
    expect(user.hasSignedUp, map["has_signed_up"]);

    Account? account = user.kakaoAccount;
    Map<String, dynamic> accountMap = map["kakao_account"];
    expect(account?.emailNeedsAgreement, accountMap["email_needs_agreement"]);
    expect(account?.email, accountMap["email"]);
    expect(account?.isEmailVerified, accountMap["is_email_verified"]);
    expect(account?.phoneNumberNeedsAgreement,
        accountMap["phone_number_needs_agreement"]);
    expect(account?.phoneNumber, accountMap["phone_number"]);

    expect(account?.ageRange, AgeRange.TWENTIES);
    expect(account?.gender, Gender.FEMALE);

    final profileMap = accountMap["profile"];
    final profile = account?.profile;
    expect(profileMap["nickname"], profile?.nickname.toString());
    expect(profileMap["thumbnail_image_url"],
        profile?.thumbnailImageUrl.toString());
    expect(
        profileMap["profile_image_url"], profile?.profileImageUrl.toString());

    expect(true, user.toJson() != null);
  });

  test("/v1/user/access_token_info 200", () async {
    var body = await loadJson("users/token_info.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponseString(body, 200);

    var tokenInfo = await _api.accessTokenInfo();
    // expect(tokenInfo.appId, map["appId"]);
    expect(tokenInfo.id, map["id"]);
    expect(tokenInfo.expiresIn, map["expires_in"]);
    expect(tokenInfo.toJson(), map);
  });

  test("/v1/user/shipping_addresses 200", () async {
    String body = await loadJson("users/addresses.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponseString(body, 200);

    var res = await _api.shippingAddresses();

    expect(res.userId, map["user_id"]);
    expect(res.needsAgreement, map["shipping_addresses_needs_agreement"]);
    var addresses = res.shippingAddresses;
    var elements = map["shipping_addresses"];
    expect(addresses?.length, elements.length);

    addresses?.asMap().forEach((index, it) {
      var element = elements[index];
      expect(it.isDefault, element["default"]);
      expect(it.id, element["id"]);
      expect(it.name, element["name"]);
      expect(it.baseAddress, element["base_address"]);
      expect(it.detailAddress, element["detail_address"]);
    });
    res.toJson();
  });

  test("/v1/user/service/terms 200", () async {
    String body = await loadJson("users/service_terms.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponseString(body, 200);

    var res = await _api.serviceTerms();
    expect(res.userId, map["user_id"]);
    var terms = res.allowedServiceTerms;
    var elements = map["allowed_service_terms"];

    expect(terms?.length, elements.length);
    terms?.asMap().forEach((index, it) {
      var element = elements[index];
      expect(it.tag, element["tag"]);
      expect(Util.dateTimeWithoutMillis(it.agreedAt), element["agreed_at"]);
    });
    res.toJson();
  });

  test("APIs with user id response 200", () async {
    String body = await loadJson("users/id.json");
    Map<String, dynamic> map = jsonDecode(body);
    _adapter.setResponseString(body, 200);

    var res = await _api.logout();
    expect(res.id, map["id"]);

    _adapter.setResponseString(body, 200);
    res = await _api.unlink();
    expect(res.id, map["id"]);
    res.toJson();
  });
}
