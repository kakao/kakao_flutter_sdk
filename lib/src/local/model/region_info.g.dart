// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionInfo _$RegionInfoFromJson(Map<String, dynamic> json) {
  return RegionInfo(
    (json['region'] as List<dynamic>).map((e) => e as String).toList(),
    json['keyword'] as String,
    json['selected_region'] as String,
  );
}

Map<String, dynamic> _$RegionInfoToJson(RegionInfo instance) =>
    <String, dynamic>{
      'region': instance.regions,
      'keyword': instance.keyword,
      'selected_region': instance.selectedRegion,
    };
