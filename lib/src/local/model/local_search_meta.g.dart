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
    RegionInfo.fromJson(json['same_name'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocalSearchMetaToJson(LocalSearchMeta instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'pageable_count': instance.pageableCount,
      'is_end': instance.isEnd,
      'same_name': instance.regionInfo,
    };
