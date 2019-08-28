// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountMeta _$CountMetaFromJson(Map<String, dynamic> json) {
  return CountMeta(
    json['total_count'] as int,
  );
}

Map<String, dynamic> _$CountMetaToJson(CountMeta instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('total_count', instance.totalCount);
  return val;
}
