// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryLike _$StoryLikeFromJson(Map<String, dynamic> json) {
  return StoryLike(
    _$enumDecodeNullable(_$EmoticonEnumMap, json['emoticon'],
        unknownValue: Emoticon.UNKNOWN),
    json['actor'] == null
        ? null
        : StoryActor.fromJson(json['actor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoryLikeToJson(StoryLike instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('emoticon', _$EmoticonEnumMap[instance.emoticon]);
  writeNotNull('actor', instance.actor?.toJson());
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

const _$EmoticonEnumMap = {
  Emoticon.LIKE: 'LIKE',
  Emoticon.COOL: 'COOL',
  Emoticon.HAPPY: 'HAPPY',
  Emoticon.SAD: 'SAD',
  Emoticon.CHEER_UP: 'CHEER_UP',
  Emoticon.UNKNOWN: 'UNKNOWN',
};
