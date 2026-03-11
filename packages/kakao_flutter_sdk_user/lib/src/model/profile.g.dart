// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  json['nickname'] as String?,
  json['thumbnail_image_url'] as String?,
  json['profile_image_url'] as String?,
  json['is_default_image'] as bool?,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'nickname': ?instance.nickname,
  'thumbnail_image_url': ?instance.thumbnailImageUrl,
  'profile_image_url': ?instance.profileImageUrl,
  'is_default_image': ?instance.isDefaultImage,
};
