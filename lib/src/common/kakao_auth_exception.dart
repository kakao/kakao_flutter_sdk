import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';

part 'kakao_auth_exception.g.dart';

/// Exception thrown by Kakao OAuth server.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class KakaoAuthException extends KakaoException {
  /// <nodoc>
  KakaoAuthException(this.error, this.errorDescription)
      : super(errorDescription);

  @JsonKey(unknownEnumValue: AuthErrorCause.UNKNOWN)
  final AuthErrorCause error;
  final String errorDescription;

  /// <nodoc>
  factory KakaoAuthException.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthExceptionFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$KakaoAuthExceptionToJson(this);

  @override
  String toString() => toJson().toString();
}

/// Specific error from Kakao OAuth.
enum AuthErrorCause {
  @JsonValue("invalid_request")
  INVALID_REQUEST,

  /// scope parameter contains invalid scope.
  @JsonValue("invalid_scope")
  INVALID_SCOPE,
  @JsonValue("invalid_grant")
  INVALID_GRANT,

  /// app is misconfigured. check if redirect uri and android key hash settings are correct.
  @JsonValue("misconfigured")
  MISCONFIGURED,
  @JsonValue("unauthorized")
  UNAUTHORIZED,
  @JsonValue("access_denied")
  ACCESS_DENIED,

  /// internal server error
  @JsonValue("server_error")
  SERVER_ERROR,
  UNKNOWN
}
