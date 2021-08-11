// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
    json['title'] as String,
    Uri.parse(json['image_url'] as String),
    Link.fromJson(json['link'] as Map<String, dynamic>),
    description: json['description'] as String?,
    imageWidth: json['image_width'] as int?,
    imageHeight: json['image_height'] as int?,
  );
}

Map<String, dynamic> _$ContentToJson(Content instance) {
  final val = <String, dynamic>{
    'title': instance.title,
    'image_url': instance.imageUrl.toString(),
    'link': instance.link.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('image_width', instance.imageWidth);
  writeNotNull('image_height', instance.imageHeight);
  return val;
}
