// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
    json['id'] as int,
    json['uuid'] as String,
    json['profile_nickname'] as String,
    Uri.parse(json['profile_thumbnail_image'] as String),
    json['favorite'] as bool,
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.userId,
      'uuid': instance.uuid,
      'profile_nickname': instance.profileNickname,
      'profile_thumbnail_image': instance.profileThumbnailImage.toString(),
      'favorite': instance.favorite,
    };
