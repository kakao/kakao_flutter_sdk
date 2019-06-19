import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Friend {
  Friend(this.userId, this.profileNickname, this.profileThumbnailImage);
  @JsonKey(name: "id")
  final int userId;
  final String profileNickname;
  final String profileThumbnailImage;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
