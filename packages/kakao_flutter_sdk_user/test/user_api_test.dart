import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/account.dart';
import 'package:kakao_flutter_sdk_user/src/model/user.dart';
import 'package:kakao_flutter_sdk_user/src/user_api.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/shared_preferences.dart';
import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/date_time.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/test_kakao_http_client.dart';
import 'test_enum_map.dart';

void main() {
  late TestKakaoHttpClient client;
  late UserApi api;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: '',
      platformProvider: FakeCommonPlatform(),
    );

    await initializeSharedPreferences();

    client = TestKakaoHttpClient();
    api = UserApi(client: client);
  });

  test('/v2/user/me 200', () async {
    final path = uriPathToFilePath(Constants.v2MePath);
    final body = await loadJson('user/$path/max.json');
    final map = jsonDecode(body);
    client.enqueueJson(map);
    final User user = await api.me();

    expect(user.id, map['id']);
    expect(user.hasSignedUp, map['has_signed_up']);

    final Account? account = user.kakaoAccount;
    final Map<String, dynamic> accountMap = map['kakao_account'];

    expect(account?.emailNeedsAgreement, accountMap['email_needs_agreement']);
    expect(account?.email, accountMap['email']);
    expect(account?.isEmailVerified, accountMap['is_email_verified']);
    expect(
      account?.phoneNumberNeedsAgreement,
      accountMap['phone_number_needs_agreement'],
    );
    expect(account?.phoneNumber, accountMap['phone_number']);

    expect(
      account?.ageRange,
      $enumDecodeNullable(
        $AgeRangeEnumMap,
        accountMap['age_range'],
        unknownValue: AgeRange.unknown,
      ),
    );

    expect(
      account?.gender,
      $enumDecodeNullable(
        $GenderEnumMap,
        accountMap['gender'],
        unknownValue: Gender.other,
      ),
    );

    final Map<String, dynamic>? profileMap = accountMap['profile'];
    final profile = account?.profile;
    expect(profileMap?['nickname'], profile?.nickname);
    expect(profileMap?['nickname'], profile?.nickname);
    expect(profileMap?['thumbnail_image_url'], profile?.thumbnailImageUrl);
    expect(profileMap?['profile_image_url'], profile?.profileImageUrl);
  });

  test('/v1/user/access_token_info 200', () async {
    final path = uriPathToFilePath(Constants.v1AccessTokenInfoPath);
    final body = await loadJson('user/$path/normal.json');
    final Map<String, dynamic> map = jsonDecode(body);
    client.enqueueJson(map);

    final tokenInfo = await api.accessTokenInfo();
    expect(tokenInfo.appId, map['app_id']);
    expect(tokenInfo.id, map['id']);
    expect(tokenInfo.expiresIn, map['expires_in']);
    expect(tokenInfo.toJson(), map);
  });

  test('/v2/user/shipping_address 200', () async {
    final path = uriPathToFilePath(Constants.v2ShippingAddressPath);
    final String body = await loadJson('user/$path/normal.json');
    final Map<String, dynamic> map = jsonDecode(body);
    client.enqueueJson(map);

    final res = await api.shippingAddress();

    expect(res.userId, map['user_id']);
    expect(res.needsAgreement, map['shipping_address_needs_agreement']);
    final address = res.shippingAddress;
    final element = map['shipping_address'];
    expect(address?.isDefault, element['is_default']);
    expect(address?.id, element['id']);
    expect(address?.name, element['name']);
    expect(address?.baseAddress, element['base_address']);
    expect(address?.detailAddress, element['detail_address']);
    res.toJson();
  });

  test('/v2/user/service_terms 200', () async {
    final path = uriPathToFilePath(Constants.v2ServiceTermsPath);
    final String body = await loadJson('user/$path/normal.json');
    final Map<String, dynamic> map = jsonDecode(body);
    client.enqueueJson(map);

    final res = await api.serviceTerms();
    expect(res.id, map['id']);
    final terms = res.serviceTerms;
    final elements = map['service_terms'];

    expect(terms?.length, elements.length);
    terms?.asMap().forEach((index, it) {
      final element = elements[index];
      expect(it.tag, element['tag']);
      expect(it.required, element['required']);
      expect(it.agreed, element['agreed']);
      expect(it.revocable, element['revocable']);

      expect(dateTimeWithoutMillis(it.agreedAt), element['agreed_at']);
    });
    res.toJson();
  });
}
