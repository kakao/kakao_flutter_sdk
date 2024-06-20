import 'dart:async';
import 'dart:js_interop';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:web/web.dart' as web;

String androidNaviIntent(String scheme, String queries) {
  var url = '$scheme?$queries';

  final intent = [
    'intent:$url#Intent',
    'package=${KakaoSdk.platforms.web.kakaoNaviOrigin}',
    'S.browser_fallback_url=${Uri.encodeComponent('${KakaoSdk.platforms.web.kakaoNaviInstallPage}?$queries')}',
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
  web.EventListener? listener;

  listener = (web.Event event) {
    if (!_isPageVisible()) {
      timer.cancel();
      web.window.removeEventListener('pagehide', listener);
      web.window.removeEventListener('visibilitychange', listener);
    }
  }.toJS;

  web.window.addEventListener('pagehide', listener);
  web.window.addEventListener('visibilitychange', listener);
}

bool _isPageVisible() {
  return !web.document.hidden;
}
