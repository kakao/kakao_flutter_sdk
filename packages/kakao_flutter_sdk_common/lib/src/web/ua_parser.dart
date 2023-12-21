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
  unknown
}

class UaParser {
  Browser detectBrowser(String ua) {
    if (ua.contains('KAKAOTALK')) {
      return Browser.kakaotalk;
    } else if (ua.contains('NAVER')) {
      return Browser.naver;
    } else if (ua.contains('Daum')) {
      return Browser.daum;
    } else if (ua.contains('Samsung')) {
      return Browser.samsung;
    } else if (ua.contains('FxiOS') || ua.contains("Firefox")) {
      return Browser.firefox;
    } else if (ua.contains('FB_IAB') || ua.contains('FBIOS')) {
      return Browser.facebook;
    } else if (ua.contains('Instagram')) {
      return Browser.instagram;
    } else if (ua.contains('Chrome') || ua.contains('CriOS')) {
      return Browser.chrome;
    } else if (ua.contains('Safari')) {
      return Browser.safari;
    }
    return Browser.unknown;
  }
}
