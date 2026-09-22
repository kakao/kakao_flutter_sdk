// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picker_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickerSettings _$PickerSettingsFromJson(Map<String, dynamic> json) =>
    PickerSettings(
      type: $enumDecodeNullable(_$ShareTypeEnumMap, json['type']),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PickerSettingsToJson(PickerSettings instance) =>
    <String, dynamic>{
      'type': ?_$ShareTypeEnumMap[instance.type],
      'limit': ?instance.limit,
    };

const _$ShareTypeEnumMap = {
  ShareType.defaultType: 'defaultType',
  ShareType.friend: 'friend',
  ShareType.chat: 'chat',
};
