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
}
