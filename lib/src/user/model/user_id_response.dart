import 'package:json_annotation/json_annotation.dart';

part 'user_id_response.g.dart';

@JsonSerializable(includeIfNull: false)
class UserIdResponse {
  /// current user's app user id
  int id;

  /// <nodoc>
  UserIdResponse(this.id);

  /// <nodoc>
  factory UserIdResponse.fromJson(Map<String, dynamic> json) =>
      _$UserIdResponseFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$UserIdResponseToJson(this);
}
