// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageInfo _$ImageInfoFromJson(Map<String, dynamic> json) {
  return ImageInfo(
    json['url'] as String,
    json['content_type'] as String,
    json['length'] as int,
    json['width'] as int,
    json['height'] as int,
  );
}

Map<String, dynamic> _$ImageInfoToJson(ImageInfo instance) => <String, dynamic>{
      'url': instance.url,
      'content_type': instance.contentType,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
    };
