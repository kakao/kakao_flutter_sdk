import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_actor.dart';

part 'story_comment.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryComment {
  /// <nodoc>
  StoryComment(this.text, this.writer);
  final String text;
  final StoryActor writer;

  /// <nodoc>
  factory StoryComment.fromJson(Map<String, dynamic> json) =>
      _$StoryCommentFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryCommentToJson(this);

  @override
  String toString() => toJson().toString();
}
