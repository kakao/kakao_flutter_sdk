// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    json['address_name'] as String,
    json['region_1depth_name'] as String,
    json['region_2depth_name'] as String,
    json['region_3depth_name'] as String,
    json['region_3depth_h_name'] as String,
    json['h_code'] as String,
    json['b_code'] as String,
    json['mountain_yn'] as String,
    json['main_address_no'] as String,
    json['sub_address_no'] as String,
    json['zip_code'] as String,
    stringToDouble(json['x']),
    stringToDouble(json['y']),
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'address_name': instance.addressName,
      'region_1depth_name': instance.region1depthName,
      'region_2depth_name': instance.region2depthName,
      'region_3depth_name': instance.region3depthName,
      'region_3depth_h_name': instance.region3depthHName,
      'h_code': instance.hCode,
      'b_code': instance.bCode,
      'mountain_yn': instance.mountainYn,
      'main_address_no': instance.mainAddressNo,
      'sub_address_no': instance.subAddressNo,
      'zip_code': instance.zipCode,
    };
