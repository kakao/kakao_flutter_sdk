class KakaoException implements Exception {
  KakaoException(this.message);

  final String message;
}

class KakaoClientException extends KakaoException {
  KakaoClientException(this.msg) : super(msg);
  final String msg;
}
