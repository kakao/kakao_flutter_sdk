// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionInfo _$RegionInfoFromJson(Map<String, dynamic> json) {
  return RegionInfo(
    (json['region'] as List)?.map((e) => e as String)?.toList(),
    json['keyword'] as String,
    json['selected_region'] as String,
  );
}

Map<String, dynamic> _$RegionInfoToJson(RegionInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('region', instance.regions);
  writeNotNull('keyword', instance.keyword);
  writeNotNull('selected_region', instance.selectedRegion);
  return val;
}
