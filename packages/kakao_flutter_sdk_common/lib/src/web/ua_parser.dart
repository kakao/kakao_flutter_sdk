enum Browser {
  chrome,
  safari,
  naver,
  daum,
  kakaotalk,
  firefox,
  samsung,
  unknown
}

class UaParser {
  final _androidRegExp = RegExp('^.*(android)', caseSensitive: false);
  final iOSRegExp = RegExp('iphone|ipod', caseSensitive: false);

  bool isAndroid(String ua) {
    if (ua.contains(_androidRegExp)) {
      return true;
    }
    return false;
  }

  bool isiOS(String ua) {
    if (ua.contains(iOSRegExp)) {
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
    } else if (ua.contains('Chrome')) {
      return Browser.chrome;
    } else if (ua.contains('Safari')) {
      return Browser.safari;
    }
    return Browser.unknown;
  }
}
