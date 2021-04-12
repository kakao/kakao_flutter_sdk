// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkProfile _$TalkProfileFromJson(Map<String, dynamic> json) {
  return TalkProfile(
    json['nickName'] as String,
    json['profileImageURL'] as String?,
    json['thumbnailURL'] as String?,
    json['countryISO'] as String,
  );
}

Map<String, dynamic> _$TalkProfileToJson(TalkProfile instance) {
  final val = <String, dynamic>{
    'nickName': instance.nickname,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('profileImageURL', instance.profileImageUrl);
  writeNotNull('thumbnailURL', instance.thumbnailUrl);
  val['countryISO'] = instance.countryISO;
  return val;
}
