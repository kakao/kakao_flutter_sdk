import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/account.dart';
import 'package:kakao_flutter_sdk_user/src/model/user.dart';
import 'package:kakao_flutter_sdk_user/src/user_api.dart';

import '../../kakao_flutter_sdk_auth/test/test_double.dart';
import '../../kakao_flutter_sdk_common/test/helper.dart';
import '../../kakao_flutter_sdk_common/test/mock_adapter.dart';
import 'test_enum_map.dart';

void main() {
  late Dio dio;
  late MockAdapter adapter;
  late UserApi api;

  TestWidgetsFlutterBinding.ensureInitialized();

  registerMockSharedPreferencesMethodChannel();

  setUp(() {
    dio = Dio();
    adapter = MockAdapter();
    dio.httpClientAdapter = adapter;
    api = UserApi(dio);
  });

  test('/v2/user/me 200', () async {
    var path = uriPathToFilePath(Constants.v2MePath);
    String body = await loadJson("user/$path/max.json");
    Map<String, dynamic> map = jsonDecode(body);
    adapter.setResponseString(body, 200);
    User user = await api.me();

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

    if (account?.ageRange != null) {
      expect(account?.ageRange,
          $enumDecode($AgeRangeEnumMap, accountMap['age_range']));
    }

    if (account?.gender != null) {
      expect(
          account?.gender, $enumDecode($GenderEnumMap, accountMap['gender']));
    }

    Map<String, dynamic>? profileMap = accountMap["profile"];
    final profile = account?.profile;
    expect(profileMap?["nickname"], profile?.nickname);
    expect(profileMap?["nickname"], profile?.nickname);
    expect(profileMap?["thumbnail_image_url"], profile?.thumbnailImageUrl);
    expect(profileMap?["profile_image_url"], profile?.profileImageUrl);
  });

  test("/v1/user/access_token_info 200", () async {
    final path = uriPathToFilePath(Constants.v1AccessTokenInfoPath);
    var body = await loadJson("user/$path/normal.json");
    Map<String, dynamic> map = jsonDecode(body);
    adapter.setResponseString(body, 200);

    var tokenInfo = await api.accessTokenInfo();
    expect(tokenInfo.appId, map["app_id"]);
    expect(tokenInfo.id, map["id"]);
    expect(tokenInfo.expiresIn, map["expires_in"]);
    expect(tokenInfo.toJson(), map);
  });

  test("/v1/user/shipping_addresses 200", () async {
    final path = uriPathToFilePath(Constants.v1ShippingAddressesPath);
    String body = await loadJson("user/$path/normal.json");
    Map<String, dynamic> map = jsonDecode(body);
    adapter.setResponseString(body, 200);

    var res = await api.shippingAddresses();

    expect(res.userId, map["user_id"]);
    expect(res.needsAgreement, map["shipping_addresses_needs_agreement"]);
    var addresses = res.shippingAddresses;
    var elements = map["shipping_addresses"];
    expect(addresses?.length, elements.length);

    addresses?.asMap().forEach((index, it) {
      var element = elements[index];
      expect(it.isDefault, element["is_default"]);
      expect(it.id, element["id"]);
      expect(it.name, element["name"]);
      expect(it.baseAddress, element["base_address"]);
      expect(it.detailAddress, element["detail_address"]);
    });
    res.toJson();
  });

  test('/v2/user/service_terms 200', () async {
    final path = uriPathToFilePath(Constants.v2ServiceTermsPath);
    String body = await loadJson('user/$path/normal.json');
    Map<String, dynamic> map = jsonDecode(body);
    adapter.setResponseString(body, 200);

    var res = await api.serviceTerms();
    expect(res.id, map['id']);
    var terms = res.serviceTerms;
    var elements = map['service_terms'];

    expect(terms?.length, elements.length);
    terms?.asMap().forEach((index, it) {
      var element = elements[index];
      expect(it.tag, element['tag']);
      expect(it.required, element['required']);
      expect(it.agreed, element['agreed']);
      expect(it.revocable, element['revocable']);
      expect(Util.dateTimeWithoutMillis(it.agreedAt), element['agreed_at']);
    });
    res.toJson();
  });
}
