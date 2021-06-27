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
    json['region_3depth_h_name'] as String?,
    json['h_code'] as String?,
    json['b_code'] as String?,
    json['mountain_yn'] as String,
    json['main_address_no'] as String,
    json['sub_address_no'] as String,
    stringToNullableDouble(json['x']),
    stringToNullableDouble(json['y']),
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  val['address_name'] = instance.addressName;
  val['region_1depth_name'] = instance.region1depthName;
  val['region_2depth_name'] = instance.region2depthName;
  val['region_3depth_name'] = instance.region3depthName;
  writeNotNull('region_3depth_h_name', instance.region3depthHName);
  writeNotNull('h_code', instance.hCode);
  writeNotNull('b_code', instance.bCode);
  val['mountain_yn'] = instance.mountainYn;
  val['main_address_no'] = instance.mainAddressNo;
  val['sub_address_no'] = instance.subAddressNo;
  return val;
}
