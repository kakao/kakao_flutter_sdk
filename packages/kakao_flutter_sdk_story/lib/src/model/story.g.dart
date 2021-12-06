// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
    json['id'] as String,
    json['url'] as String,
    json['content'] as String,
    DateTime.parse(json['created_at'] as String),
    _$enumDecodeNullable(_$StoryTypeEnumMap, json['media_type'],
        unknownValue: StoryType.NOT_SUPPORTED),
    json['comment_count'] as int,
    json['like_count'] as int,
    (json['media'] as List<dynamic>?)
        ?.map((e) => StoryImage.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['likes'] as List<dynamic>?)
        ?.map((e) => StoryLike.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['comments'] as List<dynamic>?)
        ?.map((e) => StoryComment.fromJson(e as Map<String, dynamic>))
        .toList(),
    _$enumDecodeNullable(_$StoryPermissionEnumMap, json['permission'],
        unknownValue: StoryPermission.UNKNOWN),
  );
}

Map<String, dynamic> _$StoryToJson(Story instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'url': instance.url,
    'content': instance.content,
    'created_at': instance.createdAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('media_type', _$StoryTypeEnumMap[instance.mediaType]);
  val['comment_count'] = instance.commentCount;
  val['like_count'] = instance.likeCount;
  writeNotNull('media', instance.media?.map((e) => e.toJson()).toList());
  writeNotNull('permission', _$StoryPermissionEnumMap[instance.permission]);
  writeNotNull('likes', instance.likes?.map((e) => e.toJson()).toList());
  writeNotNull('comments', instance.comments?.map((e) => e.toJson()).toList());
  return val;
}

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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$StoryTypeEnumMap = {
  StoryType.NOTE: 'NOTE',
  StoryType.PHOTO: 'PHOTO',
  StoryType.NOT_SUPPORTED: 'NOT_SUPPORTED',
};

const _$StoryPermissionEnumMap = {
  StoryPermission.PUBLIC: 'PUBLIC',
  StoryPermission.FRIEND: 'FRIEND',
  StoryPermission.ONLY_ME: 'ONLY_ME',
  StoryPermission.UNKNOWN: 'UNKNOWN',
};
