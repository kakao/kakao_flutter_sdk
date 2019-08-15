// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushTokenInfo _$PushTokenInfoFromJson(Map<String, dynamic> json) {
  return PushTokenInfo(
    json['user_id'] as String,
    json['device_id'] as String,
    _$enumDecodeNullable(_$PushTypeEnumMap, json['push_type'],
        unknownValue: PushType.UNKNOWN),
    json['push_token'] as String,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
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
  writeNotNull('push_type', _$PushTypeEnumMap[instance.pushType]);
  writeNotNull('push_token', instance.pushToken);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PushTypeEnumMap = {
  PushType.GCM: 'gcm',
  PushType.APNS: 'apns',
  PushType.UNKNOWN: 'UNKNOWN',
};
