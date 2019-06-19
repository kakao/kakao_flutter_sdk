import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/friend.dart';

part 'friends_response.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class FriendsResponse {
  FriendsResponse(this.friends, this.totalCount, this.beforeUrl, this.afterUrl);
  @JsonKey(name: "elements")
  final List<Friend> friends;
  final int totalCount;
  final String beforeUrl;
  final String afterUrl;

  factory FriendsResponse.fromJson(Map<String, dynamic> json) =>
      _$FriendsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FriendsResponseToJson(this);
}
