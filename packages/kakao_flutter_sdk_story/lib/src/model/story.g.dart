// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      json['id'] as String,
      json['url'] as String,
      json['content'] as String,
      DateTime.parse(json['created_at'] as String),
      $enumDecodeNullable(_$StoryTypeEnumMap, json['media_type'],
          unknownValue: StoryType.notSupported),
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
      $enumDecodeNullable(_$StoryPermissionEnumMap, json['permission'],
          unknownValue: StoryPermission.unknown),
    );

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

const _$StoryTypeEnumMap = {
  StoryType.note: 'NOTE',
  StoryType.photo: 'PHOTO',
  StoryType.notSupported: 'NOT_SUPPORTED',
};

const _$StoryPermissionEnumMap = {
  StoryPermission.public: 'PUBLIC',
  StoryPermission.friend: 'FRIEND',
  StoryPermission.onlyMe: 'ONLY_ME',
  StoryPermission.unknown: 'UNKNOWN',
};
