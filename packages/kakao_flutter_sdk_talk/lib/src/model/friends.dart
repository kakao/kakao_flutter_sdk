import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_talk/src/model/friend.dart';

part 'friends.g.dart';

/// 친구 목록 조회 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class Friends {
  final List<Friend>? elements;
  final int totalCount;

  /// 조회된 친구 중 즐겨찾기에 등록된 친구 수
  final int? favoriteCount;
  final String? beforeUrl;
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
