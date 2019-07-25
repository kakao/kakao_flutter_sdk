export 'kakao_auth_exception.dart';
export 'kakao_api_exception.dart';

class KakaoException implements Exception {
  KakaoException(this.message);

  final String message;
}

class KakaoClientException extends KakaoException {
  KakaoClientException(this.msg) : super(msg);
  final String msg;

  @override
  String toString() {
    return "KakaoClientException: $msg";
  }
}
