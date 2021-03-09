// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryLike _$StoryLikeFromJson(Map<String, dynamic> json) {
  return StoryLike(
    _$enumDecode(_$EmoticonEnumMap, json['emoticon'],
        unknownValue: Emoticon.UNKNOWN),
    StoryActor.fromJson(json['actor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoryLikeToJson(StoryLike instance) => <String, dynamic>{
      'emoticon': _$EmoticonEnumMap[instance.emoticon],
      'actor': instance.actor.toJson(),
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

const _$EmoticonEnumMap = {
  Emoticon.LIKE: 'LIKE',
  Emoticon.COOL: 'COOL',
  Emoticon.HAPPY: 'HAPPY',
  Emoticon.SAD: 'SAD',
  Emoticon.CHEER_UP: 'CHEER_UP',
  Emoticon.UNKNOWN: 'UNKNOWN',
};
