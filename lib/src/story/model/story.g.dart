// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
    json['id'] as String,
    Uri.parse(json['url'] as String),
    json['content'] as String,
    DateTime.parse(json['created_at'] as String),
    _$enumDecode(_$StoryTypeEnumMap, json['media_type'],
        unknownValue: StoryType.NOT_SUPPORTED),
    json['comment_count'] as int,
    json['like_count'] as int,
    (json['media'] as List<dynamic>)
        .map((e) => StoryImage.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['likes'] as List<dynamic>)
        .map((e) => StoryLike.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['comments'] as List<dynamic>)
        .map((e) => StoryComment.fromJson(e as Map<String, dynamic>))
        .toList(),
    _$enumDecode(_$StoryPermissionEnumMap, json['permission'],
        unknownValue: StoryPermission.UNKNOWN),
  );
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url.toString(),
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'media_type': _$StoryTypeEnumMap[instance.mediaType],
      'comment_count': instance.commentCount,
      'like_count': instance.likeCount,
      'media': instance.images.map((e) => e.toJson()).toList(),
      'permission': _$StoryPermissionEnumMap[instance.permission],
      'likes': instance.likes.map((e) => e.toJson()).toList(),
      'comments': instance.comments.map((e) => e.toJson()).toList(),
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
