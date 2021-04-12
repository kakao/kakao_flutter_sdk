// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['nickname'] as String,
    json['thumbnail_image_url'] as String?,
    json['profile_image_url'] as String?,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) {
  final val = <String, dynamic>{
    'nickname': instance.nickname,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('thumbnail_image_url', instance.thumbnailImageUrl);
  writeNotNull('profile_image_url', instance.profileImageUrl);
  return val;
}
