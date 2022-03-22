import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Kakao SDK의 싱글턴 Context
class KakaoSdk {
  KakaoSdk._();

  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  /// Kakao Natvie App Key
  /// SDK를 사용하기 전에 반드시 초기화 필요
  static late String nativeKey;
  static late String jsKey;

  static String sdkVersion = "1.1.0";

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

  static Future<PackageInfo> get packageInfo async =>
      await PackageInfo.fromPlatform();

  static Future<String> get appVer async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> get packageName async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static String get platformAppKey {
    if (kIsWeb) {
      return KakaoSdk.jsKey;
    }
    return KakaoSdk.nativeKey;
  }

  static void init({
    String? nativeAppKey,
    String? javaScriptAppKey,
    ServerHosts? serviceHosts,
    bool? loggingEnabled,
  }) {
    if (nativeAppKey == null) {
      throw KakaoClientException("Native App Key is required");
    }

    nativeKey = nativeAppKey;
    jsKey = javaScriptAppKey ?? "";
    hosts = serviceHosts ?? ServerHosts();
    logging = loggingEnabled ?? false;
  }
}

// List of hosts used by Kakao API.
/// @nodoc
class ServerHosts {
  final String kapi = "kapi.kakao.com";
  final String kauth = "kauth.kakao.com";
  final String sharer = "sharer.kakao.com";
  final String pf = "pf.kakao.com";
}
