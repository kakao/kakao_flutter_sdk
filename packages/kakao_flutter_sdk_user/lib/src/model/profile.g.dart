// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['nickname'] as String?,
    json['thumbnail_image_url'] as String?,
    json['profile_image_url'] as String?,
    json['is_default_image'] as bool?,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('nickname', instance.nickname);
  writeNotNull('thumbnail_image_url', instance.thumbnailImageUrl);
  writeNotNull('profile_image_url', instance.profileImageUrl);
  writeNotNull('is_default_image', instance.isDefaultImage);
  return val;
}
