import 'package:json_annotation/json_annotation.dart';

part 'user_id_response.g.dart';

/// KO: 사용자 회원번호 응답 클래스
/// <br>
/// EN: Class for user ID response
@JsonSerializable(includeIfNull: false)
class UserIdResponse {
  /// KO: 회원번호
  /// <br>
  /// EN: User ID
  int id;

  /// @nodoc
  UserIdResponse(this.id);

  /// @nodoc
  factory UserIdResponse.fromJson(Map<String, dynamic> json) =>
      _$UserIdResponseFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserIdResponseToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
