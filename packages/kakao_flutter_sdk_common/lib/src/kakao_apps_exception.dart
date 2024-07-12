import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';

part 'kakao_apps_exception.g.dart';

/// KO: Apps 에러
/// <br>
/// EN: Apps error
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class KakaoAppsException extends KakaoException {
  /// @nodoc
  KakaoAppsException(this.code, this.msg) : super(msg);

  /// KO: 에러 코드
  /// <br>
  /// EN: Error code
  @JsonKey(name: 'error_code', unknownEnumValue: AppsErrorCause.unknown)
  final AppsErrorCause code;

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  @JsonKey(name: "error_msg")
  final String msg;

  /// @nodoc
  factory KakaoAppsException.fromJson(Map<String, dynamic> json) =>
      _$KakaoAppsExceptionFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$KakaoAppsExceptionToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// KO: Apps 에러 원인
/// <br>
/// EN: Cause of Apps error
enum AppsErrorCause {
  /// KO: 서버 내부에서 처리 중 에러가 발생한 경우
  /// <br>
  /// EN: An Error occurred during the internal processing on the server
  @JsonValue("KAE001")
  internalServerError,

  /// KO: 잘못된 요청을 전달한 경우
  /// <br>
  /// EN: Passed wrong request
  @JsonValue("KAE002")
  invalidRequest,

  /// KO: 잘못된 파라미터를 전달한 경우
  /// <br>
  /// EN: Passed wrong parameters
  @JsonValue("KAE003")
  invalidParameter,

  /// KO: 유효시간이 만료된 경우
  /// <br>
  /// EN: Validity period has expired
  @JsonValue("KAE004")
  timeExpired,

  /// KO: 카카오톡 채널 정보를 확인할 수 없는 경우
  /// <br>
  /// EN: Unable to check Kakoa Talk channel information
  @JsonValue("KAE005")
  invalidChannel,

  /// KO: 카카오톡 채널이 추가 불가능 상태인 경우
  /// <br>
  /// EN: Kakao Talk channel in a state that cannot be added
  @JsonValue("KAE006")
  illegalStateChannel,

  /// KO: 브라우저를 지원하지 않는 경우
  /// <br>
  /// EN: Unsupported browser
  @JsonValue("KAE007")
  unsupported,

  /// KO: 사용할 수 없는 앱 타입인 경우
  /// <br>
  /// EN: Unavailable app type
  @JsonValue("KAE101")
  appTypeError,

  /// KO: 필요한 동의항목이 설정되지 않은 경우
  /// <br>
  /// EN: Required consent items are not set
  @JsonValue("KAE102")
  appScopeError,

  /// KO: 앱에 사용 권한이 업는 API를 호출한 경우
  /// <br>
  /// EN: Requested an API using an app that does not have permission
  @JsonValue("KAE103")
  permissionError,

  /// KO: 잘못된 타입의 앱 키를 전달한 경우
  /// <br>
  /// EN: Passed wrong type app key
  @JsonValue("KAE104")
  appKeyTypeError,

  /// KO: 앱과 연결되지 않은 카카오톡 채널 정보를 전달한 경우
  /// <br>
  /// EN: Passed KAkao Talk channel is not connected to the app
  @JsonValue("KAE105")
  appChannelNotConnected,

  /// KO: 사용자 인증에 실패한 경우
  /// <br>
  /// EN: Failed user authentication
  @JsonValue("KAE201")
  authError,

  /// KO: 앱에 연결되지 않은 사용자가 API를 호출한 경우
  /// <br>
  /// EN: Requested an API by users not connected to the app
  @JsonValue("KAE202")
  notRegisteredUser,

  /// KO: 필요한 동의항목이 동의 상태가 아닌 경우
  /// <br>
  /// EN: Required consent items are not agreed to
  @JsonValue("KAE203")
  invalidScope,

  /// KO: 필요한 서비스 약관이 동의 상태가 아닌 경우
  /// <br>
  /// EN: Required service terms are not agreed to
  @JsonValue("KAE204")
  accountTermsError,

  /// KO: 로그인이 필요한 경우
  /// <br>
  /// EN: Login is required
  @JsonValue("KAE205")
  loginRequired,

  /// KO: 등록되지 않은 배송지 ID를 전달한 경우
  /// <br>
  /// EN: Unregistered delivery ID
  @JsonValue("KAE206")
  invalidShippingAddressId,
  unknown,
}
