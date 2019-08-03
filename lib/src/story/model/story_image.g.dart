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

Map<String, dynamic> _$StoryImageToJson(StoryImage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('xlarge', instance.xlarge);
  writeNotNull('large', instance.large);
  writeNotNull('medium', instance.medium);
  writeNotNull('small', instance.small);
  writeNotNull('original', instance.original);
  return val;
}
