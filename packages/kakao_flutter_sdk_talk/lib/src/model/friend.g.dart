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
  'id': ?instance.id,
  'uuid': instance.uuid,
  'profile_nickname': ?instance.profileNickname,
  'profile_thumbnail_image': ?instance.profileThumbnailImage,
  'favorite': ?instance.favorite,
  'allowed_msg': ?instance.allowedMsg,
};
