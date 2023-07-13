import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v1ShippingAddressesPath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = UserShippingAddresses.fromJson(expected);

        expect(response.userId, expected['user_id']);
        expect(response.needsAgreement,
            expected['shipping_addresses_needs_agreement']);

        for (int i = 0; i < (response.shippingAddresses?.length ?? 0); i++) {
          var shippingAddress = response.shippingAddresses![i];
          var expectedShippingAddress = expected['shipping_addresses'][i];
          expect(shippingAddress.id, expectedShippingAddress['id']);
          expect(shippingAddress.name, expectedShippingAddress['name']);
          expect(
              shippingAddress.isDefault, expectedShippingAddress['is_default']);

          if (shippingAddress.updatedAt != null) {
            expect(
              shippingAddress.updatedAt,
              Util.fromTimeStamp(expectedShippingAddress['updated_at']),
            );
          }

          expect(shippingAddress.type, expectedShippingAddress['type']);
          expect(shippingAddress.baseAddress,
              expectedShippingAddress['base_address']);
          expect(shippingAddress.receiverName,
              expectedShippingAddress['receiver_name']);
          expect(shippingAddress.receiverPhoneNumber1,
              expectedShippingAddress['receiver_phone_number1']);
          expect(shippingAddress.receiverPhoneNumber2,
              expectedShippingAddress['receiver_phone_number2']);
          expect(shippingAddress.zoneNumber,
              expectedShippingAddress['zone_number']);
          expect(shippingAddress.zipCode, expectedShippingAddress['zip_code']);
        }
      });
    }

    parse('empty');
    parse('normal');
  });

  group('Enum Test', () {
    test('ScopeType Test', () {
      expect(ScopeType.privacy, $enumDecode($ScopeTypeEnumMap, 'PRIVACY'));
      expect(ScopeType.service, $enumDecode($ScopeTypeEnumMap, 'SERVICE'));
    });
  });
}
