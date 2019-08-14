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
    Util.fromTimeStamp(json['updated_at'] as int),
    json['type'] as String,
    json['base_address'] as String,
    json['detail_address'] as String,
    json['receiver_name'] as String,
    json['receiver_phone_number1'] as String,
    json['receiver_phone_number2'] as String,
    json['zone_number'] as String,
    json['zip_code'] as String,
  );
}

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('is_default', instance.isDefault);
  writeNotNull('updated_at', Util.fromDateTime(instance.updatedAt));
  writeNotNull('type', instance.type);
  writeNotNull('base_address', instance.baseAddress);
  writeNotNull('detail_address', instance.detailAddress);
  writeNotNull('receiver_name', instance.receiverName);
  writeNotNull('receiver_phone_number1', instance.receiverPhoneNumber1);
  writeNotNull('receiver_phone_number2', instance.receiverPhoneNumber2);
  writeNotNull('zone_number', instance.zoneNumber);
  writeNotNull('zip_code', instance.zipCode);
  return val;
}
