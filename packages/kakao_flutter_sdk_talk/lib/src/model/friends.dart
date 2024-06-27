import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friend.dart';

part 'friends.g.dart';

/// KO: 친구 목록
/// <br>
/// EN: Friend list
@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class Friends {
  /// KO: 친구 목록
  /// <br>
  /// EN: Friend list
  final List<Friend>? elements;

  /// KO: 친구 수
  /// <br>
  /// EN: Number of friends
  final int totalCount;

  /// KO: 즐겨찾기 친구 수
  /// <br>
  /// EN: Number of favorite friends
  final int? favoriteCount;

  /// KO: 이전 페이지 URL
  /// <br>
  /// EN: URL for the prior page
  final String? beforeUrl;

  /// KO: 다음 페이지 URL
  /// <br>
  /// EN: URL for the next page
  final String? afterUrl;

  /// @nodoc
  Friends(this.elements, this.totalCount, this.favoriteCount, this.beforeUrl,
      this.afterUrl);

  /// @nodoc
  factory Friends.fromJson(Map<String, dynamic> json) =>
      _$FriendsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$FriendsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
