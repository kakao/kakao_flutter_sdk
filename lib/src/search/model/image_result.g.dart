// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageResult _$ImageResultFromJson(Map<String, dynamic> json) {
  return ImageResult(
    json['collection'] as String,
    json['thumbnail_url'] == null
        ? null
        : Uri.parse(json['thumbnail_url'] as String),
    json['image_url'] == null ? null : Uri.parse(json['image_url'] as String),
    json['width'] as int,
    json['height'] as int,
    json['display_sitename'] as String,
    json['doc_url'] == null ? null : Uri.parse(json['doc_url'] as String),
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
  );
}

Map<String, dynamic> _$ImageResultToJson(ImageResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('collection', instance.collection);
  writeNotNull('thumbnail_url', instance.thumbnailUrl?.toString());
  writeNotNull('image_url', instance.imageUrl?.toString());
  writeNotNull('width', instance.width);
  writeNotNull('height', instance.height);
  writeNotNull('display_sitename', instance.displaySitename);
  writeNotNull('doc_url', instance.docUrl?.toString());
  writeNotNull('datetime', instance.datetime?.toIso8601String());
  return val;
}
