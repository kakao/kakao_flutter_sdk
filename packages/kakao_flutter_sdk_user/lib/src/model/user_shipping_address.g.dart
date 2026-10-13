// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shipping_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserShippingAddress _$UserShippingAddressFromJson(Map<String, dynamic> json) =>
    UserShippingAddress(
      (json['user_id'] as num?)?.toInt(),
      json['shipping_address_needs_agreement'] as bool?,
      json['shipping_address'] == null
          ? null
          : ShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$UserShippingAddressToJson(
  UserShippingAddress instance,
) => <String, dynamic>{
  'user_id': ?instance.userId,
  'shipping_address_needs_agreement': ?instance.needsAgreement,
  'shipping_address': ?instance.shippingAddress?.toJson(),
};
