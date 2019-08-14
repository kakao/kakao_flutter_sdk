import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/plus_friend_info.dart';

part 'plus_friends_response.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class PlusFriendsResponse {
  /// <nodoc>
  PlusFriendsResponse(this.userId, this.plusFriends);
  int userId;
  List<PlusFriendInfo> plusFriends;

  /// <nodoc>
  factory PlusFriendsResponse.fromJson(Map<String, dynamic> json) =>
      _$PlusFriendsResponseFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$PlusFriendsResponseToJson(this);
}
