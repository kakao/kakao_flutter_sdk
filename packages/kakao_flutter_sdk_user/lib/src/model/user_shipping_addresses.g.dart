// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shipping_addresses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserShippingAddresses _$UserShippingAddressesFromJson(
        Map<String, dynamic> json) =>
    UserShippingAddresses(
      (json['user_id'] as num?)?.toInt(),
      json['shipping_addresses_needs_agreement'] as bool?,
      (json['shipping_addresses'] as List<dynamic>?)
          ?.map((e) => ShippingAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserShippingAddressesToJson(
        UserShippingAddresses instance) =>
    <String, dynamic>{
      if (instance.userId case final value?) 'user_id': value,
      if (instance.needsAgreement case final value?)
        'shipping_addresses_needs_agreement': value,
      if (instance.shippingAddresses?.map((e) => e.toJson()).toList()
          case final value?)
        'shipping_addresses': value,
    };
