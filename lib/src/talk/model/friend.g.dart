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
    json['profile_thumbnail_image'] == null
        ? null
        : Uri.parse(json['profile_thumbnail_image'] as String),
    json['favorite'] as bool,
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.userId);
  writeNotNull('uuid', instance.uuid);
  writeNotNull('profile_nickname', instance.profileNickname);
  writeNotNull(
      'profile_thumbnail_image', instance.profileThumbnailImage?.toString());
  writeNotNull('favorite', instance.favorite);
  return val;
}
