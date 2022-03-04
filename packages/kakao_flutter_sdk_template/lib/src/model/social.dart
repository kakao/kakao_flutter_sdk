import 'package:json_annotation/json_annotation.dart';

part 'social.g.dart';

/// 좋아요 수, 댓글 수 등의 소셜 정보를 표현하기 위해 사용되는 오브젝트
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Social {
  /// 콘텐츠의 좋아요 수
  final int? likeCount;

  /// 콘텐츠의 댓글 수
  final int? commentCount;

  /// 콘텐츠의 공유 수
  final int? sharedCount;

  /// 콘텐츠의 조회 수
  final int? viewCount;

  /// 콘텐츠의 구독 수
  final int? subscriberCount;

  /// @nodoc
  Social({
    this.likeCount,
    this.commentCount,
    this.sharedCount,
    this.viewCount,
    this.subscriberCount,
  });

  /// @nodoc
  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
