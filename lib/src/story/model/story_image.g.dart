// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryImage _$StoryImageFromJson(Map<String, dynamic> json) {
  return StoryImage(
    json['xlarge'] as String,
    json['large'] as String,
    json['medium'] as String,
    json['small'] as String,
    json['original'] as String,
  );
}

Map<String, dynamic> _$StoryImageToJson(StoryImage instance) =>
    <String, dynamic>{
      'xlarge': instance.xlarge,
      'large': instance.large,
      'medium': instance.medium,
      'small': instance.small,
      'original': instance.original,
    };
