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
      if (instance.users?.map((e) => e.toJson()).toList() case final value?)
        'users': value,
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
      if (instance.id case final value?) 'id': value,
      'uuid': instance.uuid,
      if (instance.profileNickname case final value?) 'profile_nickname': value,
      if (instance.profileThumbnailImage case final value?)
        'profile_thumbnail_image': value,
      if (instance.favorite case final value?) 'favorite': value,
    };
