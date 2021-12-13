// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryLike _$StoryLikeFromJson(Map<String, dynamic> json) {
  return StoryLike(
    _$enumDecode(_$EmotionEnumMap, json['emotion'],
        unknownValue: Emotion.unknown),
    StoryActor.fromJson(json['actor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoryLikeToJson(StoryLike instance) => <String, dynamic>{
      'emotion': _$EmotionEnumMap[instance.emotion],
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

const _$EmotionEnumMap = {
  Emotion.like: 'LIKE',
  Emotion.cool: 'COOL',
  Emotion.happy: 'HAPPY',
  Emotion.sad: 'SAD',
  Emotion.cheerUp: 'CHEER_UP',
  Emotion.unknown: 'UNKNOWN',
};
