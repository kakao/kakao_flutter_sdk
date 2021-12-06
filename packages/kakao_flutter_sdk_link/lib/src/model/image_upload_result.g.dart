// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadResult _$ImageUploadResultFromJson(Map<String, dynamic> json) {
  return ImageUploadResult(
    ImageInfos.fromJson(json['infos'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ImageUploadResultToJson(ImageUploadResult instance) =>
    <String, dynamic>{
      'infos': instance.infos,
    };
