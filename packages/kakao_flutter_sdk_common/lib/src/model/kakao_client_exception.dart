import 'kakao_exception.dart';

/// KO: 클라이언트 에러
/// <br>
/// EN: Client errors
class KakaoClientException extends KakaoException {
  /// @nodoc
  KakaoClientException(this.reason, this.msg) : super(msg);

  /// @nodoc
  static const String notSupportedMessage =
      'This SDK operation is not supported on this platform.';

  /// @nodoc
  factory KakaoClientException.notSupported() {
    return KakaoClientException(
      ClientErrorCause.notSupported,
      notSupportedMessage,
    );
  }

  /// KO: 에러 원인
  /// <br>
  /// EN: Error cause
  final ClientErrorCause reason;

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String msg;

  /// @nodoc
  @override
  String toString() {
    return 'KakaoClientException ${reason.name}: $msg';
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
  illegalState,
}
