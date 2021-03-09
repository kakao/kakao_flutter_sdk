// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['nickname'] as String,
    Uri.parse(json['thumbnail_image_url'] as String),
    Uri.parse(json['profile_image_url'] as String),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'thumbnail_image_url': instance.thumbnailImageUrl.toString(),
      'profile_image_url': instance.profileImageUrl.toString(),
    };
