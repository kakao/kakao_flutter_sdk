// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
      (json['id'] as num?)?.toInt(),
      json['uuid'] as String,
      json['profile_nickname'] as String?,
      json['profile_thumbnail_image'] as String?,
      json['favorite'] as bool?,
      json['allowed_msg'] as bool?,
    );

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'uuid': instance.uuid,
      if (instance.profileNickname case final value?) 'profile_nickname': value,
      if (instance.profileThumbnailImage case final value?)
        'profile_thumbnail_image': value,
      if (instance.favorite case final value?) 'favorite': value,
      if (instance.allowedMsg case final value?) 'allowed_msg': value,
    };
