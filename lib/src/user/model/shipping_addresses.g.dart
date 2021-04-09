// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_addresses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddresses _$ShippingAddressesFromJson(Map<String, dynamic> json) {
  return ShippingAddresses(
    json['user_id'] as int,
    json['shipping_addresses_needs_agreement'] as bool,
    (json['shipping_addresses'] as List<dynamic>?)
        ?.map((e) => ShippingAddress.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ShippingAddressesToJson(ShippingAddresses instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'shipping_addresses_needs_agreement': instance.needsAgreement,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('shipping_addresses',
      instance.shippingAddresses?.map((e) => e.toJson()).toList());
  return val;
}
