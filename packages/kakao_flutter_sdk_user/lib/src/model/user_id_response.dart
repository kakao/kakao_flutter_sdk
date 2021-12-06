import 'package:kakao_flutter_sdk_auth/auth.dart';

part 'user_id_response.g.dart';

@JsonSerializable(includeIfNull: false)
class UserIdResponse {
  /// 회원번호
  int id;

  /// @nodoc
  UserIdResponse(this.id);

  /// @nodoc
  factory UserIdResponse.fromJson(Map<String, dynamic> json) =>
      _$UserIdResponseFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserIdResponseToJson(this);
}
