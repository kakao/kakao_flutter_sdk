// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryProfile _$StoryProfileFromJson(Map<String, dynamic> json) {
  return StoryProfile(
    json['nickName'] as String?,
    json['profileImageURL'] as String?,
    json['thumbnailURL'] as String?,
    json['bgImageURL'] as String?,
    json['permalink'] as String?,
    json['birthday'] as String?,
    json['birthdayType'] as String?,
  );
}

Map<String, dynamic> _$StoryProfileToJson(StoryProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('nickName', instance.nickname);
  writeNotNull('profileImageURL', instance.profileImageUrl);
  writeNotNull('thumbnailURL', instance.thumbnailUrl);
  writeNotNull('bgImageURL', instance.bgImageUrl);
  writeNotNull('permalink', instance.permalink);
  writeNotNull('birthday', instance.birthday);
  writeNotNull('birthdayType', instance.birthdayType);
  return val;
}
