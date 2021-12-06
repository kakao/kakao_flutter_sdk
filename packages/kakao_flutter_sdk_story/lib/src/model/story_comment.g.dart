// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryComment _$StoryCommentFromJson(Map<String, dynamic> json) {
  return StoryComment(
    json['text'] as String,
    StoryActor.fromJson(json['writer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoryCommentToJson(StoryComment instance) =>
    <String, dynamic>{
      'text': instance.text,
      'writer': instance.writer.toJson(),
    };
