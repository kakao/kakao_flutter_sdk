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
    stringToDouble(json['x']),
    stringToDouble(json['y']),
  );
}

Map<String, dynamic> _$RoadAddressToJson(RoadAddress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('address_name', instance.addressName);
  writeNotNull('region_1depth_name', instance.region1depthName);
  writeNotNull('region_2depth_name', instance.region2depthName);
  writeNotNull('region_3depth_name', instance.region3depthName);
  writeNotNull('road_name', instance.roadName);
  writeNotNull('underground_yn', instance.undergroundYn);
  writeNotNull('main_building_no', instance.mainBuildingNo);
  writeNotNull('sub_building_no', instance.subBuildingNo);
  writeNotNull('building_name', instance.buildingName);
  writeNotNull('zone_no', instance.zoneNo);
  return val;
}
