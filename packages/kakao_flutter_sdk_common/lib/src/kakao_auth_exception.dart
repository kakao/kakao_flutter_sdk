import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';

part 'kakao_auth_exception.g.dart';

/// KO: 인증 및 인가 에러 응답
/// <br>
/// EN: Response for authorization or authentication errors
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class KakaoAuthException extends KakaoException {
  /// @nodoc
  KakaoAuthException(this.error, this.errorDescription)
      : super(errorDescription);

  /// KO: 에러 코드
  /// <br>
  /// EN: Error code
  @JsonKey(unknownEnumValue: AuthErrorCause.unknown)
  final AuthErrorCause error;

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String? errorDescription;

  /// @nodoc
  factory KakaoAuthException.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthExceptionFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$KakaoAuthExceptionToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// KO: 인증 및 인가 에러 원인
/// <br>
/// EN: Causes of authentication or authorization errors
enum AuthErrorCause {
  /// KO: 잘못된 파라미터를 전달한 경우
  /// <br>
  /// EN: Passed wrong parameters
  @JsonValue("invalid_request")
  invalidRequest,

  /// KO: 잘못된 앱 키를 전달한 경우
  /// <br>
  /// EN: Passed with the wrong app key
  @JsonValue("invalid_client")
  invalidClient,

  /// KO: 잘못된 동의항목 ID를 전달한 경우
  /// <br>
  /// EN: Passed with invalid scope IDs
  @JsonValue("invalid_scope")
  invalidScope,

  /// KO: 리프레시 토큰이 만료되었거나 존재하지 않는 경우
  /// <br>
  /// EN: The refresh token has expired or does not exist
  @JsonValue("invalid_grant")
  invalidGrant,

  /// KO: 앱의 플랫폼 설정이 올바르지 않은 경우
  /// <br>
  /// EN: Platform settings of the app are misconfigured
  @JsonValue("misconfigured")
  misconfigured,

  /// KO: 앱에 사용 권한이 없는 경우
  /// <br>
  /// EN: The app does not have permission
  @JsonValue("unauthorized")
  unauthorized,

  /// KO: 사용자가 동의 화면에서 카카오 로그인을 취소한 경우
  /// <br>
  /// EN: The user canceled Kakao Login at the consent screen
  @JsonValue("access_denied")
  accessDenied,

  /// KO: 서버 에러
  /// <br>
  /// EN: Server error
  @JsonValue("server_error")
  serverError,

  /// KO: 알 수 없음
  /// <br>
  /// EN: Unknown
  unknown
}
