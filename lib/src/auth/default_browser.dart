import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

Future<String> launchWithBrowserTab(Uri url, [String redirectUri]) {
  if (url.scheme != 'http' && url.scheme != 'https') {
    throw PlatformException(
      code: 'NOT_A_WEB_SCHEME',
      message: 'Default browsers only supports URL of http or https scheme.',
    );
  }
  var args = {"url": url.toString()};
  if (redirectUri != null) {
    args["redirect_uri"] = redirectUri;
  }
  return _channel.invokeMethod("launchWithBrowserTab", args);
}
