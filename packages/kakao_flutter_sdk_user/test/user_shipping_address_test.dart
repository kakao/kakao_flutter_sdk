import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2ShippingAddressPath);
        final body = await loadJson('user/$path/$data.json');
        final expected = jsonDecode(body);
        final response = UserShippingAddress.fromJson(expected);

        expect(response.userId, expected['user_id']);
        expect(
          response.needsAgreement,
          expected['shipping_address_needs_agreement'],
        );

        final shippingAddress = response.shippingAddress;
        final expectedShippingAddress = expected['shipping_address'];
        if (expectedShippingAddress == null) {
          expect(shippingAddress, isNull);
        } else {
          expect(shippingAddress, isNotNull);
          expect(shippingAddress!.id, expectedShippingAddress['id']);
          expect(shippingAddress.name, expectedShippingAddress['name']);
          expect(
            shippingAddress.isDefault,
            expectedShippingAddress['is_default'],
          );
          expect(
            shippingAddress.updatedAt,
            ShippingAddress.fromTimeStamp(
              expectedShippingAddress['updated_at'],
            ),
          );
          expect(shippingAddress.type, expectedShippingAddress['type']);
          expect(
            shippingAddress.baseAddress,
            expectedShippingAddress['base_address'],
          );
          expect(
            shippingAddress.detailAddress,
            expectedShippingAddress['detail_address'],
          );
          expect(
            shippingAddress.receiverName,
            expectedShippingAddress['receiver_name'],
          );
          expect(
            shippingAddress.receiverPhoneNumber1,
            expectedShippingAddress['receiver_phone_number1'],
          );
          expect(
            shippingAddress.receiverPhoneNumber2,
            expectedShippingAddress['receiver_phone_number2'],
          );
          expect(
            shippingAddress.zoneNumber,
            expectedShippingAddress['zone_number'],
          );
          expect(shippingAddress.zipCode, expectedShippingAddress['zip_code']);
        }
        expect(response.toJson(), expected);
      });
    }

    parse('empty');
    parse('normal');

    test('forbidden', () async {
      final path = uriPathToFilePath(Constants.v2ShippingAddressPath);
      final body = await loadJson('user/$path/forbidden.json');
      final expected = jsonDecode(body);
      final exception = KakaoApiException.fromJson(expected);

      expect(exception.code, ApiErrorCause.unsupportedApi);
      expect(exception.msg, expected['msg']);
    });
  });

  group('Enum Test', () {
    test('ScopeType Test', () {
      expect(
        ScopeType.privacy,
        $enumDecode(
          $ScopeTypeEnumMap,
          'PRIVACY',
          unknownValue: ScopeType.unknown,
        ),
      );
      expect(
        ScopeType.service,
        $enumDecode(
          $ScopeTypeEnumMap,
          'SERVICE',
          unknownValue: ScopeType.unknown,
        ),
      );
      expect(
        ScopeType.unknown,
        $enumDecode($ScopeTypeEnumMap, 'test', unknownValue: ScopeType.unknown),
      );
    });
  });
}
