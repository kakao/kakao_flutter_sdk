// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedUsers _$SelectedUsersFromJson(Map<String, dynamic> json) =>
    SelectedUsers(
      totalCount: (json['selectedTotalCount'] as num).toInt(),
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => SelectedUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SelectedUsersToJson(SelectedUsers instance) =>
    <String, dynamic>{
      'selectedTotalCount': instance.totalCount,
      'users': ?instance.users?.map((e) => e.toJson()).toList(),
    };

SelectedUser _$SelectedUserFromJson(Map<String, dynamic> json) => SelectedUser(
  id: json['id'] as String?,
  uuid: json['uuid'] as String,
  profileNickname: json['profile_nickname'] as String?,
  profileThumbnailImage: json['profile_thumbnail_image'] as String?,
  favorite: json['favorite'] as bool?,
);

Map<String, dynamic> _$SelectedUserToJson(SelectedUser instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'uuid': instance.uuid,
      'profile_nickname': ?instance.profileNickname,
      'profile_thumbnail_image': ?instance.profileThumbnailImage,
      'favorite': ?instance.favorite,
    };
