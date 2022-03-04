import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_comment.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_image.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_like.dart';

part 'story.g.dart';

/// 스토리 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class Story {
  /// 내스토리 정보의 id (포스트 id)
  final String id;

  /// 내스토리 정보의 id (포스트 id)
  final String url;

  /// 포스팅 내용
  final String content;

  /// 작성된 시간
  final DateTime createdAt;

  /// 미디어 형
  @JsonKey(unknownEnumValue: StoryType.notSupported)
  final StoryType? mediaType;

  /// 댓글 수
  final int commentCount;

  /// 좋아요 수
  final int likeCount;

  /// 미디어 목록
  final List<StoryImage>? media;

  /// 공개 범위
  @JsonKey(unknownEnumValue: StoryPermission.unknown)
  final StoryPermission?
      permission; // TODO: unknownEnumValue should allow non-null type but it doesn't.

  /// 좋아요 정보 목록
  final List<StoryLike>? likes;

  /// 댓글 목록
  final List<StoryComment>? comments;

  /// @nodoc
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

  /// @nodoc
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// 스토리의 미디어 형식 열거형
enum StoryType {
  /// 텍스트 형식
  @JsonValue("NOTE")
  note,

  /// 이미지 형식
  @JsonValue("PHOTO")
  photo,

  /// 지원되지 않는 미디어 형식
  @JsonValue("NOT_SUPPORTED")
  notSupported
}

/// 스토리의 공개 범위
enum StoryPermission {
  /// 전체 공개
  @JsonValue('PUBLIC')
  public,

  /// 친구 공개
  @JsonValue('FRIEND')
  friend,

  /// 나만 보기
  @JsonValue('ONLY_ME')
  onlyMe,

  @JsonValue('UNKNOWN')
  unknown
}

/// @nodoc
String? permissionToParams(StoryPermission? permission) {
  return permission == StoryPermission.public
      ? "A"
      : permission == StoryPermission.friend
          ? "F"
          : permission == StoryPermission.onlyMe
              ? "M"
              : null;
}
