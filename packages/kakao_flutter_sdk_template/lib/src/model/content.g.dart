// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      title: json['title'] as String?,
      imageUrl: json['image_url'] == null
          ? null
          : Uri.parse(json['image_url'] as String),
      link: Link.fromJson(json['link'] as Map<String, dynamic>),
      description: json['description'] as String?,
      imageWidth: (json['image_width'] as num?)?.toInt(),
      imageHeight: (json['image_height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContentToJson(Content instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('image_url', instance.imageUrl?.toString());
  val['link'] = instance.link.toJson();
  writeNotNull('description', instance.description);
  writeNotNull('image_width', instance.imageWidth);
  writeNotNull('image_height', instance.imageHeight);
  return val;
}
