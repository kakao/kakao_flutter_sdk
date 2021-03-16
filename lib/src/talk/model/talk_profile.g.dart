// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) {
  return TalkProfile(
    json['nickName'] as String,
    Uri.parse(json['profileImageURL'] as String),
    Uri.parse(json['thumbnailURL'] as String),
    json['countryISO'] as String,
  );
}

Map<String, dynamic> _$TalkProfileToJson(TalkProfile instance) =>
    <String, dynamic>{
      'nickName': instance.nickname,
      'profileImageURL': instance.profileImageUrl.toString(),
      'thumbnailURL': instance.thumbnailUrl.toString(),
      'countryISO': instance.countryISO,
    };
