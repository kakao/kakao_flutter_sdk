// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_search_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalSearchMeta _$LocalSearchMetaFromJson(Map<String, dynamic> json) {
  return LocalSearchMeta(
    json['total_count'] as int,
    json['pageable_count'] as int,
    json['is_end'] as bool,
    json['same_name'] == null
        ? null
        : RegionInfo.fromJson(json['same_name'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocalSearchMetaToJson(LocalSearchMeta instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('total_count', instance.totalCount);
  writeNotNull('pageable_count', instance.pageableCount);
  writeNotNull('is_end', instance.isEnd);
  writeNotNull('same_name', instance.regionInfo);
  return val;
}
