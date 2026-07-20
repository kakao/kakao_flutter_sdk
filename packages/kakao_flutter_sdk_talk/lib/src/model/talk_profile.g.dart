// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) => TalkProfile(
  (json['id'] as num).toInt(),
  json['nickName'] as String?,
  json['profileImageURL'] as String?,
  json['thumbnailURL'] as String?,
  json['countryISO'] as String?,
);

Map<String, dynamic> _$TalkProfileToJson(TalkProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': ?instance.nickname,
      'profileImageURL': ?instance.profileImageUrl,
      'thumbnailURL': ?instance.thumbnailUrl,
      'countryISO': ?instance.countryISO,
    };
