import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';

part 'kakao_api_exception.g.dart';

/// KO: API 에러 응답
/// <br>
/// EN: Response for API errors
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class KakaoApiException extends KakaoException {
  /// @nodoc
  KakaoApiException(this.code, this.msg,
      {this.apiType, this.requiredScopes, this.allowedScopes})
      : super(msg);

  /// KO: 에러 코드
  /// <br>
  /// EN: Error code
  @JsonKey(unknownEnumValue: ApiErrorCause.unknown)
  final ApiErrorCause code;

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String msg;

  /// KO: API 종류
  /// <br>
  /// EN: API type
  final String? apiType;

  /// KO: 사용자가 동의해야 하는 동의항목
  /// <br>
  /// EN: Scopes that the user must agree to
  final List<String>? requiredScopes;

  /// KO: 사용자가 동의한 동의항목
  /// <br>
  /// EN: Scopes that user agreed to
  final List<String>? allowedScopes;

  /// @nodoc
  factory KakaoApiException.fromJson(Map<String, dynamic> json) =>
      _$KakaoApiExceptionFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$KakaoApiExceptionToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// KO: API 에러 원인
/// <br>
/// EN: Causes of API errors
enum ApiErrorCause {
  /// KO: 서버 내부에서 처리 중 에러가 발생한 경우
  /// <br>
  /// EN: An Error occurred during the internal processing in the server
  @JsonValue(-1)
  internalError,

  /// KO: 필수 파라미터가 포함되지 않았거나, 파라미터 값이 올바르지 않은 경우
  /// <br>
  /// EN: Requested without required parameters or using invalid values
  @JsonValue(-2)
  illegalParams,

  /// KO: API 사용에 필요한 사전 설정을 완료하지 않은 경우
  /// <br>
  /// EN: Required prerequisites for the API are not completed
  @JsonValue(-3)
  unsupportedApi,

  /// KO: 카카오계정이 제재되었거나, 카카오계정에 제한된 동작을 요청한 경우
  /// <br>
  /// EN: Requested by a blocked Kakao Account, or requested restricted actions to the Kakao Account
  @JsonValue(-4)
  blockedAction,

  /// KO: 사용자가 동의 화면에서 카카오 로그인을 취소한 경우
  /// <br>
  /// EN: The user canceled Kakao Login at the consent screen
  @JsonValue(-5)
  accessDenied,

  /// KO: 제공 종료된 API를 호출한 경우
  /// <br>
  /// EN: Requested a deprecated API
  @JsonValue(-9)
  deprecatedApi,

  /// KO: 사용량 제한을 초과한 경우
  /// <br>
  /// EN: Exceeded the quota
  @JsonValue(-10)
  apiLimitExceeded,

  /// KO: 앱과 연결되지 않은 사용자가 요청한 경우
  /// <br>
  /// EN: Requested by a user who is not linked to the app
  @JsonValue(-101)
  notRegisteredUser,

  /// KO: 이미 앱과 연결되어 있는 사용자에 대해 연결하기 요청한 경우
  /// <br>
  /// EN: Requested manual sign-up to a linked user
  @JsonValue(-102)
  alreadyRegisteredUser,

  /// KO: 휴면 상태, 또는 존재하지 않는 카카오계정으로 요청한 경우
  /// <br>
  /// EN: Requested with a Kakao Account that is in the dormant state or does not exist
  @JsonValue(-103)
  accountDoesNotExist,

  /// KO: 앱에 추가하지 않은 사용자 프로퍼티 키 값을 불러오거나 저장하려고 한 경우
  /// <br>
  /// EN: Requested to retrieve or save value for not registered user properties key
  @JsonValue(-201)
  propertyKeyDoesNotExist,

  /// KO: 등록되지 않은 앱 키로 요청했거나, 존재하지 않는 앱에 대해 요청한 경우
  /// <br>
  /// EN: Requested with an app key of not registered app, or requested to an app that does not exist
  @JsonValue(-301)
  appDoesNotExist,

  /// KO: 유효하지 않은 앱 키나 액세스 토큰으로 요청했거나, 앱 정보가 등록된 앱 정보와 일치하지 않는 경우
  /// <br>
  /// EN: Requested with an invalid app key or an access token, or the app information is not equal to the registered app information
  @JsonValue(-401)
  invalidToken,

  /// KO: 접근하려는 리소스에 대해 사용자 동의를 받지 않은 경우
  /// <br>
  /// EN: User has not agreed to the scope of the desired resource
  @JsonValue(-402)
  insufficientScope,

  /// KO: 연령인증 필요
  /// <br>
  /// EN: Age verification is required
  @JsonValue(-405)
  requiredAgeVerification,

  /// KO: 앱에 설정된 제한 연령보다 사용자의 연령이 낮음
  /// <br>
  /// EN: User age does not meet the app's age limit
  @JsonValue(-406)
  underAgeLimit,

  /// KO: 카카오톡 미가입 사용자가 카카오톡 API를 호출한 경우
  /// <br>
  /// EN: Users not signed up for Kakao Talk requested the Kakao Talk APIs
  @JsonValue(-501)
  notTalkUser,

  /// KO: 받는 이가 보내는 이의 친구가 아닌 경우
  /// <br>
  /// EN: Receiver is not a friend of the sender
  @JsonValue(-502)
  notFriend,

  /// KO: 지원되지 않는 기기로 메시지를 전송한 경우
  /// <br>
  /// EN: Sent message to an unsupported device
  @JsonValue(-504)
  userDeviceUnsupported,

  /// KO: 받는 이가 프로필 비공개로 설정한 경우
  /// <br>
  /// EN: The receiver turned off the profile visibility
  @JsonValue(-530)
  talkMessageDisabled,

  /// KO: 보내는 이가 한 달 동안 보낼 수 있는 쿼터를 초과한 경우
  /// <br>
  /// EN: The sender exceeded the monthly quota for sending messages
  @JsonValue(-531)
  talkSendMessageMonthlyLimitExceed,

  /// KO: 보내는 이가 하루 동안 보낼 수 있는 쿼터를 초과한 경우
  /// <br>
  /// EN: The sender exceeded the daily quota for sending messages
  @JsonValue(-532)
  talkSendMessageDailyLimitExceed,

  /// KO: 업로드 가능한 이미지 최대 용량을 초과한 경우
  /// <br>
  /// EN: Exceeded the maximum size of images to upload
  @JsonValue(-602)
  imageUploadSizeExceeded,

  /// KO: 카카오 플랫폼 내부에서 요청 처리 중 타임아웃이 발생한 경우
  /// <br>
  /// EN: Timeout occurred during the internal processing in the server
  @JsonValue(-603)
  serverTimeOut,

  /// KO: 업로드할 수 있는 최대 이미지 개수를 초과한 경우
  /// <br>
  /// EN: Exceeded the maximum number of images to upload
  @JsonValue(-606)
  imageMaxUploadCountExceed,

  /// KO: 등록되지 않은 개발자의 앱키나 등록되지 않은 개발자의 앱키로 구성된 액세스 토큰으로 요청한 경우
  /// <br>
  /// EN: Requested with an app key of not registered developer, or an access token issued by an app key of not registered developer
  @JsonValue(-903)
  developerDoesNotExist,

  /// KO: 서비스 점검 중
  /// <br>
  /// EN: Under the service maintenance
  @JsonValue(-9798)
  underMaintenance,

  /// KO: 알 수 없음
  /// <br>
  /// EN: Unknown
  unknown
}
