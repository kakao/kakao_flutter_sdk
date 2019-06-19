import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_comment.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_image.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_like.dart';

part 'story.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class Story {
  Story(
      this.id,
      this.url,
      this.content,
      this.createdAt,
      this.mediaType,
      this.commentCount,
      this.likeCount,
      this.images,
      this.likes,
      this.comments,
      this.permission);
  final String id;
  final String url;
  final String content;
  final String createdAt;
  final String mediaType;
  final int commentCount;
  final int likeCount;
  @JsonKey(name: "media")
  final List<StoryImage> images;
  final List<StoryLike> likes;
  final List<StoryComment> comments;
  final String permission;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
