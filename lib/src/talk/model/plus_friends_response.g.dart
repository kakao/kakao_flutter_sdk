// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plus_friends_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlusFriendsResponse _$PlusFriendsResponseFromJson(Map<String, dynamic> json) {
  return PlusFriendsResponse(
      json['user_id'] as int,
      (json['plus_friends'] as List)
          ?.map((e) => e == null
              ? null
              : PlusFriendInfo.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PlusFriendsResponseToJson(
        PlusFriendsResponse instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'plus_friends': instance.plusFriends
    };
