import 'package:json_annotation/json_annotation.dart';

part 'social.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Social {
  Social(
      {this.likeCount,
      this.commentCount,
      this.sharedCount,
      this.viewCount,
      this.subscriberCount});
  final int likeCount;
  final int commentCount;
  final int sharedCount;
  final int viewCount;
  final int subscriberCount;

  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
