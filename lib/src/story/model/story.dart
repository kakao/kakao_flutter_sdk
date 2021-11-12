import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_comment.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_image.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_like.dart';

part 'story.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class Story {
  final String id;

  // web url of this story.
  final String url;
  final String content;
  final DateTime createdAt;
  @JsonKey(unknownEnumValue: StoryType.NOT_SUPPORTED)
  final StoryType? mediaType;
  final int commentCount;
  final int likeCount;
  final List<StoryImage>? media;
  @JsonKey(unknownEnumValue: StoryPermission.UNKNOWN)
  final StoryPermission?
      permission; // TODO: unknownEnumValue should allow non-null type but it doesn't.

  /// Only present in [StoryApi.myStory()], always null in [StoryApi.myStories()].
  final List<StoryLike>? likes;

  /// Only present in [StoryApi.myStory()], always null in [StoryApi.myStories()].
  final List<StoryComment>? comments;

  /// <nodoc>
  Story(
      this.id,
      this.url,
      this.content,
      this.createdAt,
      this.mediaType,
      this.commentCount,
      this.likeCount,
      this.media,
      this.likes,
      this.comments,
      this.permission);

  /// <nodoc>
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  @override
  String toString() => toJson().toString();
}

enum StoryType { NOTE, PHOTO, NOT_SUPPORTED }

enum StoryPermission {
  /// Visible to all.
  PUBLIC,

  /// Visible only to friends.
  FRIEND,

  /// Visible only to me.
  ONLY_ME,
  UNKNOWN
}

String? permissionToParams(StoryPermission? permission) {
  return permission == StoryPermission.PUBLIC
      ? "A"
      : permission == StoryPermission.FRIEND
          ? "F"
          : permission == StoryPermission.ONLY_ME
              ? "M"
              : null;
}
