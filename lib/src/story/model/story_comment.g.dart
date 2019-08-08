// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryComment _$StoryCommentFromJson(Map<String, dynamic> json) {
  return StoryComment(
    json['text'] as String,
    json['writer'] == null
        ? null
        : StoryActor.fromJson(json['writer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoryCommentToJson(StoryComment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('writer', instance.writer?.toJson());
  return val;
}
