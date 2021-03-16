// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cafe _$CafeFromJson(Map<String, dynamic> json) {
  return Cafe(
    json['title'] as String,
    json['contents'] as String,
    Uri.parse(json['url'] as String),
    DateTime.parse(json['datetime'] as String),
    Uri.parse(json['thumbnail'] as String),
    json['cafename'] as String,
  );
}

Map<String, dynamic> _$CafeToJson(Cafe instance) => <String, dynamic>{
      'title': instance.title,
      'contents': instance.contents,
      'url': instance.url.toString(),
      'datetime': instance.datetime.toIso8601String(),
      'thumbnail': instance.thumbnail.toString(),
      'cafename': instance.cafeName,
    };
