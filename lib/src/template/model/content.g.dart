// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
    json['title'] as String,
    json['image_url'] == null ? null : Uri.parse(json['image_url'] as String),
    json['link'] == null
        ? null
        : Link.fromJson(json['link'] as Map<String, dynamic>),
    imageWidth: json['image_width'] as int,
    imageHeight: json['image_height'] as int,
  );
}

Map<String, dynamic> _$ContentToJson(Content instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('image_url', instance.imageUrl?.toString());
  writeNotNull('link', instance.link?.toJson());
  writeNotNull('image_width', instance.imageWidth);
  writeNotNull('image_height', instance.imageHeight);
  return val;
}
