import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';

part 'kakao_auth_exception.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class KakaoAuthException extends KakaoException {
  KakaoAuthException(this.error, this.errorDescription)
      : super(errorDescription);

  @JsonKey(defaultValue: AuthErrorCause.UNKNOWN)
  final AuthErrorCause error;
  final String errorDescription;

  factory KakaoAuthException.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthExceptionFromJson(json);
  Map<String, dynamic> toJson() => _$KakaoAuthExceptionToJson(this);
}

enum AuthErrorCause {
  @JsonValue("invalid_request")
  INVALID_REQUEST,
  @JsonValue("invalid_request")
  INVALID_SCOPE,
  @JsonValue("invalid_grant")
  INVALID_GRANT,
  @JsonValue("misconfigured")
  MISCONFIGURED,
  @JsonValue("unauthorized")
  UNAUTHORIZED,
  @JsonValue("access_denied")
  ACCESS_DENIED,
  @JsonValue("server_error")
  SERVER_ERROR,
  UNKNOWN
}
