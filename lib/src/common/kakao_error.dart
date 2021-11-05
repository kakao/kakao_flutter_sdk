/// 카카오 SDK 를 사용하면서 발생하는 에러 정보.
class KakaoException implements Exception {
  KakaoException(this.message);

  final String? message;
}

/// SDK 내에서 발생하는 클라이언트 에러
class KakaoClientException extends KakaoException {
  KakaoClientException(this.msg) : super(msg);
  final String msg;

  @override
  String toString() {
    return "KakaoClientException: $msg";
  }
}
