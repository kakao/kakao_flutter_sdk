import 'dart:async';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class KakaoContext {
  static const MethodChannel _channel =
      const MethodChannel('kakao_flutter_sdk');

  static String clientId;

  static Future<String> get origin async {
    final String origin = await _channel.invokeMethod("getOrigin");
    return origin;
  }

  static Future<String> get kaHeader async {
    final String kaHeader = await _channel.invokeMethod("getKaHeader");
    return kaHeader;
  }

  static Future<String> get appVer async {
    var platform = await PackageInfo.fromPlatform();
    return platform.version;
  }
}
