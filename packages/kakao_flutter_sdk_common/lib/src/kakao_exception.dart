import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// 카카오 SDK 를 사용하면서 발생하는 에러 정보
class KakaoException implements Exception {
  KakaoException(this.message);

  final String? message;

  bool isInvalidTokenError() {
    if (this is KakaoAuthException &&
        (this as KakaoAuthException).error == AuthErrorCause.invalidGrant) {
      return true;
    } else if (this is KakaoApiException &&
        (this as KakaoApiException).code == ApiErrorCause.invalidToken) {
      return true;
    }
    return false;
  }
}

/// SDK 내에서 발생하는 클라이언트 에러
class KakaoClientException extends KakaoException {
  final ClientErrorCause reason;
  final String msg;

  KakaoClientException(this.reason, this.msg) : super(msg);

  /// @nodoc
  @override
  String toString() {
    return "KakaoClientException ${reason.name}: $msg";
  }
}

/// [KakaoClientException]의 발생 원인
enum ClientErrorCause {
  /// 기타 에러
  unknown,

  /// 요청 취소
  cancelled,

  /// API 요청에 사용할 토큰이 없음
  tokenNotFound,

  /// 지원되지 않는 기능
  notSupported,

  /// 잘못된 파라미터
  badParameter,

  /// 정상적으로 실행할 수 없는 상태
  illegalState
}
