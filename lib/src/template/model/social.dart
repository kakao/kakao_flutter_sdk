import 'package:json_annotation/json_annotation.dart';

part 'social.g.dart';

/// Represents social section data of message template v2.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Social {
  /// <nodoc>
  Social(
      {this.likeCount,
      this.commentCount,
      this.sharedCount,
      this.viewCount,
      this.subscriberCount});

  final int? likeCount;
  final int? commentCount;
  final int? sharedCount;
  final int? viewCount;
  final int? subscriberCount;

  /// <nodoc>
  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
