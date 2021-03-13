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

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'region_type': instance.regionType,
      'address_name': instance.addressName,
      'region_1depth_name': instance.region1depthName,
      'region_2depth_name': instance.region2depthName,
      'region_3depth_name': instance.region3depthName,
      'region_4depth_name': instance.region4depthName,
      'code': instance.code,
    };
