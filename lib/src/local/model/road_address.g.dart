// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'road_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadAddress _$RoadAddressFromJson(Map<String, dynamic> json) {
  return RoadAddress(
    json['address_name'] as String,
    json['region_1depth_name'] as String,
    json['region_2depth_name'] as String,
    json['region_3depth_name'] as String,
    json['road_name'] as String,
    json['underground_yn'] as String,
    json['main_building_no'] as String,
    json['sub_building_no'] as String,
    json['building_name'] as String,
    json['zone_no'] as String,
    stringToNullableDouble(json['x']),
    stringToNullableDouble(json['y']),
  );
}

Map<String, dynamic> _$RoadAddressToJson(RoadAddress instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'address_name': instance.addressName,
      'region_1depth_name': instance.region1depthName,
      'region_2depth_name': instance.region2depthName,
      'region_3depth_name': instance.region3depthName,
      'road_name': instance.roadName,
      'underground_yn': instance.undergroundYn,
      'main_building_no': instance.mainBuildingNo,
      'sub_building_no': instance.subBuildingNo,
      'building_name': instance.buildingName,
      'zone_no': instance.zoneNo,
    };
