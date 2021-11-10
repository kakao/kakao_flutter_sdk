// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shipping_addresses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserShippingAddresses _$UserShippingAddressesFromJson(
    Map<String, dynamic> json) {
  return UserShippingAddresses(
    json['user_id'] as int?,
    json['shipping_addresses_needs_agreement'] as bool,
    (json['shipping_addresses'] as List<dynamic>?)
        ?.map((e) => ShippingAddress.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UserShippingAddressesToJson(
    UserShippingAddresses instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  val['shipping_addresses_needs_agreement'] = instance.needsAgreement;
  writeNotNull('shipping_addresses',
      instance.shippingAddresses?.map((e) => e.toJson()).toList());
  return val;
}
