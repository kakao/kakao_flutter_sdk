import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';

part 'kakao_api_exception.g.dart';

/// 카카오 API 호출 시 에러 응답
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class KakaoApiException extends KakaoException {
  /// @nodoc
  KakaoApiException(this.code, this.msg,
      {this.apiType, this.requiredScopes, this.allowedScopes})
      : super(msg);

  /// 에러 코드
  @JsonKey(unknownEnumValue: ApiErrorCause.unknown)
  final ApiErrorCause code;

  /// 자세한 에러 설명
  final String msg;

  final String? apiType;

  /// API 호출을 위해 추가로 필요한 동의 항목
  final List<String>? requiredScopes;

  // List of scopes this user already agreed to.
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

/// [KakaoApiException]의 발생 원인
enum ApiErrorCause {
  /// 서버 내부에서 처리 중에 에러가 발생한 경우
  @JsonValue(-1)
  internalError,

  /// 필수 인자가 포함되지 않은 경우나 호출 인자값의 데이타 타입이 적절하지 않거나 허용된 범위를 벗어난 경우
  @JsonValue(-2)
  illegalParams,

  /// 해당 API를 사용하기 위해 필요한 기능(간편가입, 동의항목, 서비스 설정 등)이 활성화 되지 않은 경우
  @JsonValue(-3)
  unsupportedApi,

  /// 계정이 제재된 경우나 해당 계정에 제재된 행동을 하는 경우
  @JsonValue(-4)
  blockedAction,

  /// 해당 API에 대한 요청 권한이 없는 경우
  @JsonValue(-5)
  accessDenied,

  /// 서비스가 종료된 API를 호출한 경우
  @JsonValue(-9)
  deprecatedApi,

  /// 허용된 요청 회수가 초과한 경우
  @JsonValue(-10)
  apiLimitExceeded,

  /// 해당 앱에 카카오계정 연결이 완료되지 않은 사용자가 호출한 경우
  @JsonValue(-101)
  notRegisteredUser,

  /// 이미 연결된 사용자에 대해 signup 시도
  @JsonValue(-102)
  alreadyRegisteredUser,

  /// 존재하지 않는 카카오계정으로 요청한 경우
  @JsonValue(-103)
  accountDoesNotExist,

  /// 사용자 정보 요청 API나 사용자 정보 저장 API 호출 시 앱에 추가하지 않은 사용자 프로퍼티 키 값을 불러오거나 저장하려고 한 경우
  @JsonValue(-201)
  propertyKeyDoesNotExist,

  /// 등록되지 않은 앱키의 요청 또는 존재하지 않는 앱으로의 요청. (앱키가 인증에 사용되는 경우는 -401 참조)
  @JsonValue(-301)
  appDoesNotExist,

  /// 유효하지 않은 앱키나 액세스 토큰으로 요청한 경우, 등록된 앱 정보와 호출된 앱 정보가 불일치 하는 경우 ex) 토큰 만료
  @JsonValue(-401)
  invalidToken,

  /// 해당 API에서 접근하는 리소스에 대해 사용자의 동의를 받지 않은 경우
  @JsonValue(-402)
  insufficientScope,

  /// TODO: add reference or remove value
  @JsonValue(-403)
  invalidOrigin,

  /// 앱의 연령제한에 대해 사용자 연령 인증 받지 않음
  @JsonValue(-405)
  requiredAgeVerification,

  /// 앱의 연령제한보다 사용자의 연령이 낮음
  @JsonValue(-406)
  underAgeLimit,

  /// 카카오톡 미가입 사용자가 카카오톡 API를 호출하였을 경우
  @JsonValue(-501)
  notTalkUser,

  /// 받는 이가 보내는 이의 친구가 아닌 경우
  @JsonValue(-502)
  notFriend,

  /// 지원되지 않는 기기로 메시지 보내는 경우
  @JsonValue(-504)
  userDeviceUnsupported,

  /// 받는 이가 메시지 수신 거부를 설정한 경우
  @JsonValue(-530)
  talkMessageDisabled,

  /// 특정 앱에서 보내는 이가 특정인에게 하루 동안 보낼 수 있는 쿼터를 초과한 경우
  @JsonValue(-531)
  talkSendMessageMonthlyLimitExceed,

  /// 특정 앱에서 보내는 이가 받는 사람 관계없이 하루 동안 보낼 수 있는 쿼터를 초과한 경우
  @JsonValue(-532)
  talkSendMessageDailyLimitExceed,

  /// 카카오스토리 가입 사용자에게만 허용된 API에서 카카오스토리 미가입 사용자가 요청한 경우
  @JsonValue(-601)
  notStoryUser,

  /// 카카오스토리 이미지 업로드 사이즈 제한 초과
  @JsonValue(-602)
  storyImageUploadSizeExceeded,

  /// 업로드,스크랩 등 오래 걸리는 API의 타임아웃
  @JsonValue(-603)
  timeOut,

  /// 카카오스토리에서 스크랩이 실패하였을 경우
  @JsonValue(-604)
  storyInvalidScrapUrl,

  /// 카카오스토리에 존재하지 않는 내스토리를 요청했을 경우
  @JsonValue(-605)
  storyInvalidPostId,

  /// 카카오스토리에서 업로드할 수 있는 최대 이미지 개수(현재 5개. 단, gif 파일은 1개)를 초과하였을 경우
  @JsonValue(-606)
  storyMaxUploadCountExceed,

  /// 등록되지 않은 개발자의 앱키나 등록되지 않은 개발자의 앱키로 구성된 액세스 토큰으로 요청한 경우
  @JsonValue(-903)
  developerDoesNotExist,

  /// 서버 점검 중
  @JsonValue(-9798)
  underMaintenance,

  /// 기타 에러
  unknown
}
