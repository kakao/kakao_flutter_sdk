// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMeta _$SearchMetaFromJson(Map<String, dynamic> json) {
  return SearchMeta(
    json['total_count'] as int,
    json['pageable_count'] as int,
    json['is_end'] as bool,
  );
}

Map<String, dynamic> _$SearchMetaToJson(SearchMeta instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'pageable_count': instance.pageableCount,
      'is_end': instance.isEnd,
    };
