// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plus_friend_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlusFriendInfo _$PlusFriendInfoFromJson(Map<String, dynamic> json) {
  return PlusFriendInfo(
    json['plus_friend_uuid'] as String,
    json['plus_friend_public_id'] as String,
    json['relation'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$PlusFriendInfoToJson(PlusFriendInfo instance) =>
    <String, dynamic>{
      'plus_friend_uuid': instance.uuid,
      'plus_friend_public_id': instance.publicId,
      'relation': instance.relation,
      'updated_at': instance.updatedAt,
    };
