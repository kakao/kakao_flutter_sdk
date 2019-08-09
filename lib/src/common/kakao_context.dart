import 'dart:async';
import 'package:flutter/services.dart';

/// Singleton context for Kakao Flutter SDK.
class KakaoContext {
  KakaoContext._();
  static const MethodChannel _channel =
      const MethodChannel('kakao_flutter_sdk');

  /// Native app key for this application from [Kakao Developers](https://developers.kakao.com).
  static String clientId;

  /// Origin value in KA header.
  ///
  /// Bundle id and Android keyhash for iOS and Android platform, respectively.
  static Future<String> get origin async {
    final String origin = await _channel.invokeMethod("getOrigin");
    return origin;
  }

  /// KA (Kakao Agent) header.
  ///
  /// This header is constructed by SDK for light platform validation and statistics purpose.
  ///
  /// ### Android example
  /// ```
  /// flutter_sdk/0.1.0 os/android-28 lang/ko-KR origin/R0tsaOaVqq4/xTZAEihCkrXS+6M= device/SM-G973N android_pkg/com.kakao.sdk.KakaoSample app_ver/0.1.0
  /// ```
  ///
  /// ### iOS example
  /// ```
  /// flutter_sdk/0.1.0 os/ios-12.4 lang/en res/414.0x896.0 device/iPhone origin/com.kakao.sdk.KakaoSample app_ver/0.1.0
  /// ```
  static Future<String> get kaHeader async {
    final String kaHeader = await _channel.invokeMethod("getKaHeader");
    return "flutter_sdk/0.1.0 $kaHeader";
  }
}
