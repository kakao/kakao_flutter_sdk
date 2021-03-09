// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageResult _$ImageResultFromJson(Map<String, dynamic> json) {
  return ImageResult(
    json['collection'] as String,
    Uri.parse(json['thumbnail_url'] as String),
    Uri.parse(json['image_url'] as String),
    json['width'] as int,
    json['height'] as int,
    json['display_sitename'] as String,
    Uri.parse(json['doc_url'] as String),
    DateTime.parse(json['datetime'] as String),
  );
}

Map<String, dynamic> _$ImageResultToJson(ImageResult instance) =>
    <String, dynamic>{
      'collection': instance.collection,
      'thumbnail_url': instance.thumbnailUrl.toString(),
      'image_url': instance.imageUrl.toString(),
      'width': instance.width,
      'height': instance.height,
      'display_sitename': instance.displaySitename,
      'doc_url': instance.docUrl.toString(),
      'datetime': instance.datetime.toIso8601String(),
    };
