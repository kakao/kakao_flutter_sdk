// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Region _$RegionFromJson(Map<String, dynamic> json) {
  return Region(
    json['region_type'] as String,
    json['address_name'] as String,
    json['region_1depth_name'] as String,
    json['region_2depth_name'] as String,
    json['region_3depth_name'] as String,
    json['region_4depth_name'] as String,
    json['code'] as String,
    stringToDouble(json['x']),
    stringToDouble(json['y']),
  );
}

Map<String, dynamic> _$RegionToJson(Region instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('region_type', instance.regionType);
  writeNotNull('address_name', instance.addressName);
  writeNotNull('region_1depth_name', instance.region1depthName);
  writeNotNull('region_2depth_name', instance.region2depthName);
  writeNotNull('region_3depth_name', instance.region3depthName);
  writeNotNull('region_4depth_name', instance.region4depthName);
  writeNotNull('code', instance.code);
  return val;
}
