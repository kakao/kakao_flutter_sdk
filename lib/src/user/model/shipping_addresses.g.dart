// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_addresses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddresses _$ShippingAddressesFromJson(Map<String, dynamic> json) {
  return ShippingAddresses(
      json['user_id'] as int,
      json['shipping_addresses_needs_agreement'] as bool,
      (json['shipping_addresses'] as List)
          ?.map((e) => e == null
              ? null
              : ShippingAddress.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ShippingAddressesToJson(ShippingAddresses instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'shipping_addresses_needs_agreement':
          instance.shippingAddressesNeedsAgreement,
      'shipping_addresses': instance.shippingAddresses
    };
