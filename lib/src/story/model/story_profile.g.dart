// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryProfile _$StoryProfileFromJson(Map<String, dynamic> json) {
  return StoryProfile(
    json['nickName'] as String,
    json['profileImageURL'] as String,
    json['thumbnailURL'] as String,
    json['permalink'] as String,
    json['birthday'] as String,
    json['birthdayType'] as String,
  );
}

Map<String, dynamic> _$StoryProfileToJson(StoryProfile instance) =>
    <String, dynamic>{
      'nickName': instance.nickname,
      'profileImageURL': instance.profileImageUrl,
      'thumbnailURL': instance.thumbnailUrl,
      'permalink': instance.permalink,
      'birthday': instance.birthday,
      'birthdayType': instance.birthdayType,
    };
