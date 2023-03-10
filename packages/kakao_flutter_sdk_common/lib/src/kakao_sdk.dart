import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// Kakao SDK의 싱글턴 Context
class KakaoSdk {
  KakaoSdk._();

  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  /// Kakao Native App Key
  /// SDK를 사용하기 전에 반드시 초기화 필요
  static late String _nativeKey;
  static late String _jsKey;

  static String sdkVersion = "1.4.2";

  static String get appKey => kIsWeb ? _jsKey : _nativeKey;

  static bool logging = false;

  // ServerHosts used by SDK.
  //
  // You can explicitly set this to your custom ServerHosts. One example can be
  //
  // ```
  // class SandboxHosts extends ServerHosts {
  // @override
  // String get kapi => "sandbox-${super.kapi}";
  //
  // @override
  // String get kauth => "sandbox-${super.kauth}";
  //
  // @override
  //  String get sharer => "sandbox-${super.sharer}";
  // }
  // ```
  static late ServerHosts hosts;

  static late PlatformSupport platforms;

  // Origin value in KA header.
  //
  // Bundle id and Android keyhash for iOS and Android platform, respectively.
  static Future<String> get origin async {
    final String origin =
        await _channel.invokeMethod(CommonConstants.getOrigin);
    return origin;
  }

  //
  // KA (Kakao Agent) header.
  //
  // This header is constructed by SDK for light platform validation and statistics purpose.
  //
  // ### Android example
  // ```
  // sdk/0.1.0 sdk_type/flutter os/android-28 lang/ko-KR origin/R0tsaOaVqq4/xTZAEihCkrXS+6M= device/SM-G973N android_pkg/com.kakao.sdk.KakaoSample app_ver/0.1.0
  // ```
  //
  // ### iOS example
  // ```
  // sdk/0.1.0 sdk_type/flutter os/ios-12.4 lang/en res/414.0x896.0 device/iPhone origin/com.kakao.sdk.KakaoSample app_ver/0.1.0
  // ```
  static Future<String> get kaHeader async {
    final String kaHeader =
        await _channel.invokeMethod(CommonConstants.getKaHeader);
    return "sdk/$sdkVersion sdk_type/flutter $kaHeader";
  }

  static Future<String> get appVer async {
    return await _channel.invokeMethod(CommonConstants.appVer);
  }

  static Future<String> get packageName async {
    return await _channel.invokeMethod(CommonConstants.packageName);
  }

  /// [내 애플리케이션]에서 확인한 앱 키로 Flutter SDK 초기화, 서비스 환경별 앱 키 사용
  /// 웹: javaScriptAppKey에 JavaScript 키 전달
  /// 앱: nativeAppKey에 네이티브 앱 키 전달
  static void init({
    String? nativeAppKey,
    String? javaScriptAppKey,
    ServerHosts? serviceHosts,
    PlatformSupport? platformSupport,
    bool? loggingEnabled,
  }) {
    if (nativeAppKey == null && javaScriptAppKey == null) {
      throw KakaoClientException(
          "A Native App Key or JavaScript App Key is required");
    }

    _nativeKey = nativeAppKey ?? "";
    _jsKey = javaScriptAppKey ?? "";
    hosts = serviceHosts ?? ServerHosts();
    platforms = platformSupport ?? PlatformSupport();
    logging = loggingEnabled ?? false;

    if (kIsWeb) {
      _channel.invokeMethod("retrieveAuthCode");
    }
  }
}
