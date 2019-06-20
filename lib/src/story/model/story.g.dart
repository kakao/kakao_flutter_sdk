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
      json['created_at'] as String,
      json['media_type'] as String,
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
          ?.map((e) => e == null
              ? null
              : StoryComment.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      _$enumDecodeNullable(_$StoryPermissionEnumMap, json['permission']));
}

Map<String, dynamic> _$StoryToJson(Story instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('url', instance.url);
  writeNotNull('content', instance.content);
  writeNotNull('created_at', instance.createdAt);
  writeNotNull('media_type', instance.mediaType);
  writeNotNull('comment_count', instance.commentCount);
  writeNotNull('like_count', instance.likeCount);
  writeNotNull('media', instance.images?.map((e) => e?.toJson())?.toList());
  writeNotNull('likes', instance.likes?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'comments', instance.comments?.map((e) => e?.toJson())?.toList());
  writeNotNull('permission', _$StoryPermissionEnumMap[instance.permission]);
  return val;
}

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

const _$StoryPermissionEnumMap = <StoryPermission, dynamic>{
  StoryPermission.PUBLIC: 'PUBLIC',
  StoryPermission.FRIEND: 'FRIEND',
  StoryPermission.ONLY_ME: 'ONLY_ME'
};
