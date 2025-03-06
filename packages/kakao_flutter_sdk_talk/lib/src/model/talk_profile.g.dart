// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) => TalkProfile(
      json['nickName'] as String?,
      json['profileImageURL'] as String?,
      json['thumbnailURL'] as String?,
      json['countryISO'] as String?,
    );

Map<String, dynamic> _$TalkProfileToJson(TalkProfile instance) =>
    <String, dynamic>{
      if (instance.nickname case final value?) 'nickName': value,
      if (instance.profileImageUrl case final value?) 'profileImageURL': value,
      if (instance.thumbnailUrl case final value?) 'thumbnailURL': value,
      if (instance.countryISO case final value?) 'countryISO': value,
    };
