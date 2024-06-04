import 'dart:async';

import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';
import 'package:kakao_flutter_sdk_common/src/web/ua_parser.dart';
import 'package:kakao_flutter_sdk_common/src/web/utility.dart';
import 'package:web/web.dart' as web;

Future<String> handleAppsApi(
  final Browser browser,
  final String transId,
  final String requestUrl,
  final String popupTitle,
) {
  final url = 'https://${KakaoSdk.hosts.apps}';
  final iframe = createHiddenIframe(transId, '$url/proxy?trans_id=$transId');
  web.document.body?.append(iframe);

  final completer = Completer<String>();

  addMessageEventListener(browser, url, completer, () => iframe.remove());

  windowOpen(
    requestUrl,
    popupTitle,
    features:
        'location=no,resizable=no,status=no,scrollbars=no,width=460,height=608',
  );
  return completer.future;
}

web.Window? windowOpen(String url, String name, {String features = ''}) {
  return web.window.open(url, name, features);
}
