// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushTokenInfo _$PushTokenInfoFromJson(Map<String, dynamic> json) {
  return PushTokenInfo(
    json['user_id'] as String,
    json['device_id'] as String,
    _$enumDecode(_$PushTypeEnumMap, json['push_type'],
        unknownValue: PushType.UNKNOWN),
    json['push_token'] as String,
    DateTime.parse(json['created_at'] as String),
    DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$PushTokenInfoToJson(PushTokenInfo instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'device_id': instance.deviceId,
      'push_type': _$PushTypeEnumMap[instance.pushType],
      'push_token': instance.pushToken,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PushTypeEnumMap = {
  PushType.GCM: 'gcm',
  PushType.APNS: 'apns',
  PushType.UNKNOWN: 'UNKNOWN',
};
