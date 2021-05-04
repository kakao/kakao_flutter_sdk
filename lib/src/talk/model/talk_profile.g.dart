// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) {
  return TalkProfile(
    json['nickName'] as String?,
    json['profileImageUrl'] as String?,
    json['thumbnailUrl'] as String?,
    json['countryISO'] as String?,
  );
}

Map<String, dynamic> _$TalkProfileToJson(TalkProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('nickName', instance.nickname);
  writeNotNull('profileImageUrl', instance.profileImageUrl);
  writeNotNull('thumbnailUrl', instance.thumbnailUrl);
  writeNotNull('countryISO', instance.countryISO);
  return val;
}
