import 'package:json_annotation/json_annotation.dart';

part 'social.g.dart';

/// KO: 소셜 정보
/// <br>
/// EN: Social information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Social {
  /// KO: 좋아요 수
  /// <br>
  /// EN: Number of likes
  final int? likeCount;

  /// KO: 댓글 수
  /// <br>
  /// EN: Number of comments
  final int? commentCount;

  /// KO: 공유 수
  /// <br>
  /// EN: Number of shares
  final int? sharedCount;

  /// KO: 조회 수
  /// <br>
  /// EN: Views
  final int? viewCount;

  /// KO: 구독 수
  /// <br>
  /// EN: Number of subscribers
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
