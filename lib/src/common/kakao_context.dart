import 'dart:async';
import 'package:flutter/services.dart';

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
    return "flutter_sdk/0.1.0 $kaHeader";
  }
}
