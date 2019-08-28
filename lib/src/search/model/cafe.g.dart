// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cafe _$CafeFromJson(Map<String, dynamic> json) {
  return Cafe(
    json['title'] as String,
    json['contents'] as String,
    json['url'] == null ? null : Uri.parse(json['url'] as String),
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
    json['thumbnail'] == null ? null : Uri.parse(json['thumbnail'] as String),
    json['cafename'] as String,
  );
}

Map<String, dynamic> _$CafeToJson(Cafe instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('contents', instance.contents);
  writeNotNull('url', instance.url?.toString());
  writeNotNull('datetime', instance.datetime?.toIso8601String());
  writeNotNull('thumbnail', instance.thumbnail?.toString());
  writeNotNull('cafename', instance.cafeName);
  return val;
}
