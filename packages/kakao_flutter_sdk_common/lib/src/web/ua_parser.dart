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
  final _androidRegExp = RegExp('^.*(android)', caseSensitive: false);
  final _iOSRegExp = RegExp('iphone|ipod', caseSensitive: false);

  bool isAndroid(String userAgent) {
    if (userAgent.contains(_androidRegExp)) {
      return true;
    }
    return false;
  }

  bool isiOS(String userAgent) {
    if (userAgent.contains(_iOSRegExp)) {
      return true;
    }
    return false;
  }

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
    } else if (ua.contains('FB_IAB')) {
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
