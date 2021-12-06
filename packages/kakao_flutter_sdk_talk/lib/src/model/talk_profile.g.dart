// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) {
  return TalkProfile(
    json['nickName'] as String?,
    json['profileImageURL'] as String?,
    json['thumbnailURL'] as String?,
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
  writeNotNull('profileImageURL', instance.profileImageUrl);
  writeNotNull('thumbnailURL', instance.thumbnailUrl);
  writeNotNull('countryISO', instance.countryISO);
  return val;
}
