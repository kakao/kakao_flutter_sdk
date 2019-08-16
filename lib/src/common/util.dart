import 'dart:async';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/story.dart';

const MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

/// Launches a given url with platform-specific default browser tab.
Future<String> launchBrowserTab(Uri uri, {String redirectUri}) {
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    throw KakaoClientException(
      'Default browsers only supports URL of http or https scheme.',
    );
  }
  var args = {"url": uri.toString(), "redirect_uri": redirectUri};
  args.removeWhere((k, v) => v == null);
  return _channel.invokeMethod("launchBrowserTab", args);
}

/// Determines whether KakaoTalk is installed on this device.
Future<bool> isKakaoTalkInstalled() async {
  return _channel.invokeMethod("isKakaoTalkInstalled");
}

/// Collection of utility methods, usually for converting data types.
class Util {
  static DateTime fromTimeStamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  static int fromDateTime(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch ~/ 1000;

  static String dateTimeWithoutMillis(DateTime dateTime) => dateTime == null
      ? null
      : "${dateTime.toIso8601String().substring(0, dateTime.toIso8601String().length - 5)}Z";
}
