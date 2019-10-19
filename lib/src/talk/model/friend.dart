import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

/// Represents a friend user in [TalkApi.friends()] API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Friend {
  /// <nodoc>
  Friend(this.userId, this.uuid, this.profileNickname,
      this.profileThumbnailImage, this.favorite);

  /// Friend's app user id, used in user mapping with third-party services.
  @JsonKey(name: "id")
  final int userId;

  final String uuid;

  /// Friend's nickname, used to display to users.
  final String profileNickname;

  /// Friend's thumbnail, used to display to users.
  final Uri profileThumbnailImage;

  final bool favorite;

  /// <nodoc>
  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
