// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) {
  return TalkProfile(
    json['nickName'] as String,
    json['profileImageURL'] as String,
    json['thumbnailURL'] as String,
    json['countryISO'] as String,
  );
}

Map<String, dynamic> _$TalkProfileToJson(TalkProfile instance) =>
    <String, dynamic>{
      'nickName': instance.nickname,
      'profileImageURL': instance.profileImageUrl,
      'thumbnailURL': instance.thumbnailUrl,
      'countryISO': instance.countryISO,
    };
