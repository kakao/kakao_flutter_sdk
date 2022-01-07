import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_actor.dart';

part 'story_comment.g.dart';

/// 카카오스토리의 댓글 정보를 담고 있는 클래스
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryComment {
  final String text;
  final StoryActor writer;

  /// @nodoc
  StoryComment(this.text, this.writer);

  /// @nodoc
  factory StoryComment.fromJson(Map<String, dynamic> json) =>
      _$StoryCommentFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryCommentToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
