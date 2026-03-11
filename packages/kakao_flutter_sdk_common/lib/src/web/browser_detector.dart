/// @nodoc
class BrowserDetector {
  BrowserDetector._();

  static Browser detect(String userAgent) {
    if (userAgent.contains('KAKAOTALK')) {
      return Browser.kakaotalk;
    } else if (userAgent.contains('NAVER')) {
      return Browser.naver;
    } else if (userAgent.contains('Daum')) {
      return Browser.daum;
    } else if (userAgent.contains('Samsung')) {
      return Browser.samsung;
    } else if (userAgent.contains('FxiOS') || userAgent.contains('Firefox')) {
      return Browser.firefox;
    } else if (userAgent.contains('FB_IAB') || userAgent.contains('FBIOS')) {
      return Browser.facebook;
    } else if (userAgent.contains('Instagram')) {
      return Browser.instagram;
    } else if (userAgent.contains('Chrome') || userAgent.contains('CriOS')) {
      return Browser.chrome;
    } else if (userAgent.contains('Safari')) {
      return Browser.safari;
    }
    return Browser.unknown;
  }
}

/// @nodoc
enum Browser {
  chrome,
  safari,
  naver,
  daum,
  kakaotalk,
  firefox,
  samsung,
  facebook,
  instagram,
  unknown,
}
