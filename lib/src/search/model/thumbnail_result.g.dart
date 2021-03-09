// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnail_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThumbnailResult _$ThumbnailResultFromJson(Map<String, dynamic> json) {
  return ThumbnailResult(
    json['title'] as String,
    json['contents'] as String,
    Uri.parse(json['url'] as String),
    DateTime.parse(json['datetime'] as String),
    Uri.parse(json['thumbnail'] as String),
  );
}

Map<String, dynamic> _$ThumbnailResultToJson(ThumbnailResult instance) =>
    <String, dynamic>{
      'title': instance.title,
      'contents': instance.contents,
      'url': instance.url.toString(),
      'datetime': instance.datetime.toIso8601String(),
      'thumbnail': instance.thumbnail.toString(),
    };
