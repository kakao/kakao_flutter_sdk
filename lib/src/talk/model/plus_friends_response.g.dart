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
        ?.toList(),
  );
}

Map<String, dynamic> _$PlusFriendsResponseToJson(PlusFriendsResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull(
      'plus_friends', instance.plusFriends?.map((e) => e?.toJson())?.toList());
  return val;
}
