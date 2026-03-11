import '../../kakao_flutter_sdk_common.dart';

/// KO: SDK 내부 동작 에러
/// <br>
/// EN: SDK internal operation errors
class KakaoException implements Exception {
  KakaoException(this.message);

  /// KO: 에러 메시지
  /// <br>
  /// EN: Error message
  final String? message;

  bool isInvalidTokenError() {
    if (this is KakaoAuthException &&
        (this as KakaoAuthException).error == AuthErrorCause.invalidGrant) {
      return true;
    }

    if (this is KakaoApiException &&
        (this as KakaoApiException).code == ApiErrorCause.invalidToken) {
      return true;
    }

    return false;
  }
}
