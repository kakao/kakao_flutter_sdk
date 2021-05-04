import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/talk/model/friend.dart';

part 'friends.g.dart';

/// Response from [TalkApi.friends()].
@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class Friends {
  final List<Friend>? elements;
  final int totalCount;

  /// Number of friends enrolled in favorites
  final int? favoriteCount;
  final String? beforeUrl;
  final String? afterUrl;

  /// <nodoc>
  Friends(this.elements, this.totalCount, this.favoriteCount, this.beforeUrl,
      this.afterUrl);

  /// <nodoc>
  factory Friends.fromJson(Map<String, dynamic> json) =>
      _$FriendsFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$FriendsToJson(this);

  @override
  String toString() => toJson().toString();
}
