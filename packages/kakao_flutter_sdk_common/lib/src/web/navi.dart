import 'dart:async';
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

String androidNaviIntent(String scheme, String queries) {
  var url = '$scheme?$queries';

  final intent = [
    'intent:$url#Intent',
    'package=com.locnall.KimGiSa',
    'S.browser_fallback_url=${Uri.encodeComponent('https://kakaonavi.kakao.com/launch/index.do?$queries')}',
    'end;'
  ].join(';');
  return intent;
}

Timer deferredFallback(String storeUrl, Function(String) fallback) {
  int timeout = 5000;

  return Timer(Duration(milliseconds: timeout), () {
    fallback(storeUrl);
  });
}

void bindPageHideEvent(Timer timer) {
  EventListener? listener;

  listener = (event) {
    if (!_isPageVisible()) {
      timer.cancel();
      html.window.removeEventListener('pagehide', listener);
      html.window.removeEventListener('visibilitychange', listener);
    }
  };

  html.window.addEventListener('pagehide', listener);
  html.window.addEventListener('visibilitychange', listener);
}

bool _isPageVisible() {
  if (html.document.hidden != null) {
    return !html.document.hidden!;
  }
  return true;
}
