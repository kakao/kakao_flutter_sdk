import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';

part 'kakao_api_exception.g.dart';

/// Exception thrown by Kakao API server.
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class KakaoApiException extends KakaoException {
  /// <nodoc>
  KakaoApiException(this.code, this.msg, this.apiType, this.requiredScopes,
      this.allowedScopes)
      : super(msg);

  @JsonKey(unknownEnumValue: ApiErrorCause.UNKNOWN)
  final ApiErrorCause code;
  final String msg;
  final String apiType;
  final List<String> requiredScopes;
  final List<String> allowedScopes;

  /// <nodoc>
  factory KakaoApiException.fromJson(Map<String, dynamic> json) =>
      _$KakaoApiExceptionFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$KakaoApiExceptionToJson(this);

  @override
  String toString() => toJson().toString();
}

/// Specific error code from Kakao API.
enum ApiErrorCause {
  @JsonValue(-1)
  INTERNAL_ERROR,
  @JsonValue(-2)
  ILLEGAL_PARAMS,
  @JsonValue(-3)
  UNSUPPORTED_API,
  @JsonValue(-4)
  BLOCKED_ACTION,
  @JsonValue(-5)
  ACCESS_DENIED,
  @JsonValue(-9)
  DEPRECATED_API,
  @JsonValue(-10)
  API_LIMIT_EXCEEDED,
  @JsonValue(-301)
  APP_DOES_NOT_EXIST,
  @JsonValue(-401)
  INVALID_TOKEN,
  @JsonValue(-403)
  INVALID_ORIGIN,
  @JsonValue(-603)
  TIME_OUT,
  @JsonValue(-903)
  DEVELOPER_DOES_NOT_EXIST,

  @JsonValue(-101)
  NOT_REGISTERED_USER,
  @JsonValue(-102)
  ALREADY_REGISTERD_USER,
  @JsonValue(-103)
  ACCOUNT_DOES_NOT_EXIST,
  @JsonValue(-402)
  INVALID_SCOPE,
  @JsonValue(-405)
  AGE_VERIFICATION_REQIRED,
  @JsonValue(-406)
  UNDER_AGE_LIMIT,

  @JsonValue(-201)
  PROPERTY_KEY_DOES_NOT_EXIST,

  @JsonValue(-501)
  NOT_TALK_USER,
  @JsonValue(-502)
  NOT_FRIEND,
  @JsonValue(-504)
  USER_DVICE_UNSUPPORTED,
  @JsonValue(-530)
  TALK_MESSAGE_DISABLED,
  @JsonValue(-531)
  TALK_SEND_MESSAGE_MONTHLY_LIMIT_EXCEEDED,
  @JsonValue(-532)
  TALK_SEND_MESSAGE_DAILY_LIMIT_EXCEEDED,

  @JsonValue(-601)
  NOT_STORY_USER,
  @JsonValue(-602)
  STORY_IMAGE_UPOLOAD_SIZE_EXCEEDED,
  @JsonValue(-604)
  STORY_INVALID_SCRAP_URL,
  @JsonValue(-605)
  STROY_INVALID_POST_ID,
  @JsonValue(-606)
  STORY_MAX_UPLOAD_COUNT_EXCEEDED,
  UNKNOWN
}
