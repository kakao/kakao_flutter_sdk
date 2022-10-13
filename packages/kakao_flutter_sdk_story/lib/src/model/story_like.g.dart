// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryLike _$StoryLikeFromJson(Map<String, dynamic> json) => StoryLike(
      $enumDecode(_$EmotionEnumMap, json['emotion'],
          unknownValue: Emotion.unknown),
      StoryActor.fromJson(json['actor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryLikeToJson(StoryLike instance) => <String, dynamic>{
      'emotion': _$EmotionEnumMap[instance.emotion]!,
      'actor': instance.actor.toJson(),
    };

const _$EmotionEnumMap = {
  Emotion.like: 'LIKE',
  Emotion.cool: 'COOL',
  Emotion.happy: 'HAPPY',
  Emotion.sad: 'SAD',
  Emotion.cheerUp: 'CHEER_UP',
  Emotion.unknown: 'UNKNOWN',
};
