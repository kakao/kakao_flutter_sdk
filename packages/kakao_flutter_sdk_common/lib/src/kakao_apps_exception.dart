import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';

part 'kakao_apps_exception.g.dart';

/// 카카오 Apps API 호출 시 에러 응답
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class KakaoAppsException extends KakaoException {
  /// @nodoc
  KakaoAppsException(this.code, this.msg) : super(msg);

  /// 에러 코드
  @JsonKey(name: 'error_code', unknownEnumValue: AppsErrorCause.unknown)
  final AppsErrorCause code;

  /// 자세한 에러 설명
  @JsonKey(name: "error_msg")
  final String msg;

  factory KakaoAppsException.fromJson(Map<String, dynamic> json) =>
      _$KakaoAppsExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$KakaoAppsExceptionToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

enum AppsErrorCause {
  /// 내부 서버 에러가 발생하는 경우
  @JsonValue("KAE001")
  internalServerError,

  /// 잘못된 요청을 사용하는 경우
  @JsonValue("KAE002")
  invalidRequest,

  /// 잘못된 파라미터를 사용하는 경우
  @JsonValue("KAE003")
  invalidParameter,

  /// 유효시간이 만료된 경우
  @JsonValue("KAE004")
  timeExpired,

  /// 채널 정보를 확인할 수 없는 경우
  @JsonValue("KAE005")
  invalidChannel,

  /// 채널이 추가 가능한 상태가 아닌 경우
  @JsonValue("KAE006")
  illegalStateChannel,

  /// 브라우저를 지원하지 않는 경우
  @JsonValue("KAE007")
  unsupported,

  /// API를 사용할 수 없는 앱 타입인 경우
  @JsonValue("KAE101")
  appTypeError,

  /// API 사용에 필요한 scope이 설정되지 않은 경우
  @JsonValue("KAE102")
  appScopeError,

  /// API 사용에 필요한 권한이 없는 경우
  @JsonValue("KAE103")
  permissionError,

  /// API 호출에 사용할 수 없는 앱키 타입으로 API를 호출하는 경우
  @JsonValue("KAE104")
  appKeyTypeError,

  /// 앱과 연결되지 않은 채널 정보로 API를 요청한 경우
  @JsonValue("KAE105")
  appChannelNotConnected,

  /// Access Token, KPIDT, 톡세션 등으로 앱 유저 인증에 실패하는 경우
  @JsonValue("KAE201")
  authFailed,

  /// 앱에 연결되지 않은 유저가 API를 호출하는 경우
  @JsonValue("KAE202")
  notRegisteredUser,

  /// API 호출에 필요한 scope에 동의하지 않은 경우
  @JsonValue("KAE203")
  invalidScope,

  /// API 사용에 필요한 계정 약관 동의가 되어 있지 않은 경우
  @JsonValue("KAE204")
  accountTermsAgreeRequired,

  /// 계정 페이지에서 배송지 콜백으로 로그인 필요 응답을 전달하는 경우
  @JsonValue("KAE205")
  loginRequired,

  /// 계정에 등록되어있지 않은 배송지 ID를 파라미터로 사용하는 경우
  @JsonValue("KAE206")
  invalidShippingAddressId,
  unknown,
}
