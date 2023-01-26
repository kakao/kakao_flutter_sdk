// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedUsers _$SelectedUsersFromJson(Map<String, dynamic> json) =>
    SelectedUsers(
      totalCount: json['selectedTotalCount'] as int,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => SelectedUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SelectedUsersToJson(SelectedUsers instance) {
  final val = <String, dynamic>{
    'selectedTotalCount': instance.totalCount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('users', instance.users?.map((e) => e.toJson()).toList());
  return val;
}

SelectedUser _$SelectedUserFromJson(Map<String, dynamic> json) => SelectedUser(
      id: json['id'] as String?,
      uuid: json['uuid'] as String,
      profileNickname: json['profile_nickname'] as String?,
      profileThumbnailImage: json['profile_thumbnail_image'] as String?,
      favorite: json['favorite'] as bool?,
    );

Map<String, dynamic> _$SelectedUserToJson(SelectedUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['uuid'] = instance.uuid;
  writeNotNull('profile_nickname', instance.profileNickname);
  writeNotNull('profile_thumbnail_image', instance.profileThumbnailImage);
  writeNotNull('favorite', instance.favorite);
  return val;
}
