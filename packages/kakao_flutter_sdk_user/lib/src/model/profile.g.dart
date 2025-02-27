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
      if (instance.nickname case final value?) 'nickname': value,
      if (instance.thumbnailImageUrl case final value?)
        'thumbnail_image_url': value,
      if (instance.profileImageUrl case final value?)
        'profile_image_url': value,
      if (instance.isDefaultImage case final value?) 'is_default_image': value,
    };
