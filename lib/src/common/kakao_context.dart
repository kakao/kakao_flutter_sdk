import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Singleton context for Kakao Flutter SDK.
class KakaoContext {
  KakaoContext._();
  static const MethodChannel _channel =
      const MethodChannel('kakao_flutter_sdk');

  /// Native app key for this application from [Kakao Developers](https://developers.kakao.com).
  static late String clientId;
  static late String javascriptClientId;

  static String sdkVersion = "0.8.2";

  /// [ServerHosts] used by SDK.
  ///
  /// You can explicitly set this to your custom [ServerHosts]. One example can be
  ///
  /// ```
  /// class SandboxHosts extends ServerHosts {
  /// @override
  /// String get kapi => "sandbox-${super.kapi}";
  ///
  /// @override
  /// String get kauth => "sandbox-${super.kauth}";
  ///
  /// @override
  ///  String get sharer => "sandbox-${super.sharer}";
  /// }
  /// ```
  static ServerHosts hosts = ServerHosts();

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
  /// sdk/0.1.0 sdk_type/flutter os/android-28 lang/ko-KR origin/R0tsaOaVqq4/xTZAEihCkrXS+6M= device/SM-G973N android_pkg/com.kakao.sdk.KakaoSample app_ver/0.1.0
  /// ```
  ///
  /// ### iOS example
  /// ```
  /// sdk/0.1.0 sdk_type/flutter os/ios-12.4 lang/en res/414.0x896.0 device/iPhone origin/com.kakao.sdk.KakaoSample app_ver/0.1.0
  /// ```
  static Future<String> get kaHeader async {
    final String kaHeader = await _channel.invokeMethod("getKaHeader");
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

  static String get platformClientId {
    if (kIsWeb) {
      return KakaoContext.javascriptClientId;
    }
    return KakaoContext.clientId;
  }
}

/// List of hosts used by Kakao API.
class ServerHosts {
  final String kapi = "kapi.kakao.com";
  final String dapi = "dapi.kakao.com";
  final String kauth = "kauth.kakao.com";
  final String sharer = "sharer.kakao.com";
  final String pf = "pf.kakao.com";
}
