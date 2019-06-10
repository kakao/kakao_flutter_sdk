// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) {
  return ShippingAddress(
      json['id'] as int,
      json['name'] as String,
      json['is_default'] as bool,
      json['updated_at'] as int,
      json['type'] as String,
      json['base_address'] as String,
      json['detail_address'] as String,
      json['receiver_name'] as String,
      json['receiver_phone_number1'] as String,
      json['receiver_phone_number2'] as String,
      json['zone_number'] as String,
      json['zip_code'] as String);
}

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_default': instance.isDefault,
      'updated_at': instance.updatedAt,
      'type': instance.type,
      'base_address': instance.baseAddress,
      'detail_address': instance.detailAddress,
      'receiver_name': instance.receiverName,
      'receiver_phone_number1': instance.receiverPhoneNumber1,
      'receiver_phone_number2': instance.receiverPhoneNumber2,
      'zone_number': instance.zoneNumber,
      'zip_code': instance.zipCode
    };
