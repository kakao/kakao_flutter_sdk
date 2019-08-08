import 'package:json_annotation/json_annotation.dart';

part 'user_id_response.g.dart';

@JsonSerializable(includeIfNull: false)
class UserIdResponse {
  UserIdResponse(this.id);
  int id;

  factory UserIdResponse.fromJson(Map<String, dynamic> json) =>
      _$UserIdResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserIdResponseToJson(this);
}
