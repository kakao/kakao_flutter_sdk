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

Map<String, dynamic> _$PushTokenInfoToJson(PushTokenInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull('device_id', instance.deviceId);
  writeNotNull('push_type', instance.pushType);
  writeNotNull('push_token', instance.pushToken);
  writeNotNull('created_at', instance.createdAt);
  writeNotNull('updated_at', instance.updatedAt);
  return val;
}
