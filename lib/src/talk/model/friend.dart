import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

/// Represents a friend user in [TalkApi.friends()] API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Friend {
  /// Friend's app user id, used in user mapping with third-party services.
  final int? id;
  final String uuid;

  /// Friend's nickname, used to display to users.
  final String? profileNickname;

  /// Friend's thumbnail, used to display to users.
  final String? profileThumbnailImage;
  final bool? favorite;

  /// Indicates whether a friend can receive a message.
  final bool? allowedMsg;

  /// <nodoc>
  Friend(this.id, this.uuid, this.profileNickname, this.profileThumbnailImage,
      this.favorite, this.allowedMsg);

  /// <nodoc>
  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
