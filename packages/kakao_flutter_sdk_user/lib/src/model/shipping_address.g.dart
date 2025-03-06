// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      (json['id'] as num).toInt(),
      json['name'] as String?,
      json['is_default'] as bool,
      Util.fromTimeStamp((json['updated_at'] as num?)?.toInt()),
      json['type'] as String?,
      json['base_address'] as String?,
      json['detail_address'] as String?,
      json['receiver_name'] as String?,
      json['receiver_phone_number1'] as String?,
      json['receiver_phone_number2'] as String?,
      json['zone_number'] as String?,
      json['zip_code'] as String?,
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.name case final value?) 'name': value,
      'is_default': instance.isDefault,
      if (Util.fromDateTime(instance.updatedAt) case final value?)
        'updated_at': value,
      if (instance.type case final value?) 'type': value,
      if (instance.baseAddress case final value?) 'base_address': value,
      if (instance.detailAddress case final value?) 'detail_address': value,
      if (instance.receiverName case final value?) 'receiver_name': value,
      if (instance.receiverPhoneNumber1 case final value?)
        'receiver_phone_number1': value,
      if (instance.receiverPhoneNumber2 case final value?)
        'receiver_phone_number2': value,
      if (instance.zoneNumber case final value?) 'zone_number': value,
      if (instance.zipCode case final value?) 'zip_code': value,
    };
