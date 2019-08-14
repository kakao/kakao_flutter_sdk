import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/friend.dart';

part 'friends_response.g.dart';

/// Response from [TalkApi.friends()].
@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class FriendsResponse {
  /// <nodoc>
  FriendsResponse(this.friends, this.totalCount, this.beforeUrl, this.afterUrl);
  @JsonKey(name: "elements")
  final List<Friend> friends;
  final int totalCount;
  final Uri beforeUrl;
  final Uri afterUrl;

  /// <nodoc>
  factory FriendsResponse.fromJson(Map<String, dynamic> json) =>
      _$FriendsResponseFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FriendsResponseToJson(this);

  @override
  String toString() => toJson().toString();
}
