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

Map<String, dynamic> _$RoadAddressToJson(RoadAddress instance) {
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
  val['road_name'] = instance.roadName;
  val['underground_yn'] = instance.undergroundYn;
  val['main_building_no'] = instance.mainBuildingNo;
  val['sub_building_no'] = instance.subBuildingNo;
  val['building_name'] = instance.buildingName;
  val['zone_no'] = instance.zoneNo;
  return val;
}
