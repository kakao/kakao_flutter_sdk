// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushTokenInfo _$PushTokenInfoFromJson(Map<String, dynamic> json) {
  return PushTokenInfo(
    json['user_id'] as String,
    json['device_id'] as String,
    json['push_type'] as String,
    json['push_token'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$PushTokenInfoToJson(PushTokenInfo instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'device_id': instance.deviceId,
      'push_type': instance.pushType,
      'push_token': instance.pushToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
