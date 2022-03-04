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
  KakaoClientException(this.msg) : super(msg);
  final String msg;

  /// @nodoc
  @override
  String toString() {
    return "KakaoClientException: $msg";
  }
}
