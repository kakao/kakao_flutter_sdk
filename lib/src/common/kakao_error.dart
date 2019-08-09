/// Exception thrown by Kakao Flutter SDK.
class KakaoException implements Exception {
  KakaoException(this.message);

  final String message;
}

/// Exception thrown on the client side.
class KakaoClientException extends KakaoException {
  KakaoClientException(this.msg) : super(msg);
  final String msg;

  @override
  String toString() {
    return "KakaoClientException: $msg";
  }
}
