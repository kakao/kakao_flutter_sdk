import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// KO: SDK 내부 동작 에러
/// <br>
/// EN: SDK internal operation errors
class KakaoException implements Exception {
  /// @nodoc
  KakaoException(this.message);

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String? message;

  /// KO: 유효하지 않은 토큰으로 인한 에러인지 확인
  /// <br>
  /// EN: Check whether the error is due to an invalid token
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

/// KO: 클라이언트 에러
/// <br>
/// EN: Client errors
class KakaoClientException extends KakaoException {
  /// KO: 에러 원인
  /// <br>
  /// EN: Error cause
  final ClientErrorCause reason;

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String msg;

  /// @nodoc
  KakaoClientException(this.reason, this.msg) : super(msg);

  /// @nodoc
  @override
  String toString() {
    return "KakaoClientException ${reason.name}: $msg";
  }
}

/// KO: 클라이언트 에러 원인
/// <br>
/// EN: Causes of client errors
enum ClientErrorCause {
  /// KO: 알 수 없음
  /// <br>
  /// EN: Unknown
  unknown,

  /// KO: 사용자가 취소한 경우
  /// <br>
  /// EN: User canceled
  cancelled,

  /// KO: API 요청에 사용할 토큰이 없는 경우
  /// <br>
  /// EN: A token for API requests not found
  tokenNotFound,

  /// KO: 지원하지 않는 기능
  /// <br>
  /// EN: Not supported feature
  notSupported,

  /// KO: 잘못된 파라미터를 전달한 경우
  /// <br>
  /// EN: Passed wrong parameters
  badParameter,

  /// KO: 요청을 정상적으로 처리할 수 없는 상태
  /// <br>
  /// EN: Illegal state to process the request
  illegalState
}
