// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryLike _$StoryLikeFromJson(Map<String, dynamic> json) {
  return StoryLike(
    _$enumDecodeNullable(_$EmoticonEnumMap, json['emoticon']),
    json['actor'] == null
        ? null
        : StoryActor.fromJson(json['actor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoryLikeToJson(StoryLike instance) => <String, dynamic>{
      'emoticon': _$EmoticonEnumMap[instance.emoticon],
      'actor': instance.actor?.toJson(),
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$EmoticonEnumMap = <Emoticon, dynamic>{
  Emoticon.LIKE: 'LIKE',
  Emoticon.COOL: 'COOL',
  Emoticon.HAPPY: 'HAPPY',
  Emoticon.SAD: 'SAD',
  Emoticon.CHEER_UP: 'CHEER_UP'
};
