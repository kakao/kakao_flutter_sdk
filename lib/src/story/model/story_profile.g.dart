// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryProfile _$StoryProfileFromJson(Map<String, dynamic> json) {
  return StoryProfile(
    json['nickName'] as String,
    Uri.parse(json['profileImageURL'] as String),
    Uri.parse(json['thumbnailURL'] as String),
    Uri.parse(json['permalink'] as String),
    json['birthday'] as String,
    json['birthdayType'] as String,
  );
}

Map<String, dynamic> _$StoryProfileToJson(StoryProfile instance) =>
    <String, dynamic>{
      'nickName': instance.nickname,
      'profileImageURL': instance.profileImageUrl.toString(),
      'thumbnailURL': instance.thumbnailUrl.toString(),
      'permalink': instance.permalink.toString(),
      'birthday': instance.birthday,
      'birthdayType': instance.birthdayType,
    };
