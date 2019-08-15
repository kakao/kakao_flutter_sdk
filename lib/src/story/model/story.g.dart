// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
    json['id'] as String,
    json['url'] == null ? null : Uri.parse(json['url'] as String),
    json['content'] as String,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    _$enumDecodeNullable(_$StoryTypeEnumMap, json['media_type'],
        unknownValue: StoryType.NOT_SUPPORTED),
    json['comment_count'] as int,
    json['like_count'] as int,
    (json['media'] as List)
        ?.map((e) =>
            e == null ? null : StoryImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['likes'] as List)
        ?.map((e) =>
            e == null ? null : StoryLike.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : StoryComment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    _$enumDecodeNullable(_$StoryPermissionEnumMap, json['permission'],
        unknownValue: StoryPermission.UNKNOWN),
  );
}

Map<String, dynamic> _$StoryToJson(Story instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('url', instance.url?.toString());
  writeNotNull('content', instance.content);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('media_type', _$StoryTypeEnumMap[instance.mediaType]);
  writeNotNull('comment_count', instance.commentCount);
  writeNotNull('like_count', instance.likeCount);
  writeNotNull('media', instance.images?.map((e) => e?.toJson())?.toList());
  writeNotNull('permission', _$StoryPermissionEnumMap[instance.permission]);
  writeNotNull('likes', instance.likes?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'comments', instance.comments?.map((e) => e?.toJson())?.toList());
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
