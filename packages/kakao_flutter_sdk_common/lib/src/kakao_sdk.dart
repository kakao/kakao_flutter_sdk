import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// KO: 주요 설정 및 초기화 클래스
/// <br>
/// EN: Class for major settings and initializing
class KakaoSdk {
  KakaoSdk._();

  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  static late String _nativeKey;
  static late String _jsKey;

  /// @nodoc
  static String sdkVersion = "1.9.6";

  /// @nodoc
  static String get appKey => kIsWeb ? _jsKey : _nativeKey;

  /// @nodoc
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
  /// @nodoc
  static late ServerHosts hosts;

  /// @nodoc
  static late PlatformSupport platforms;

  // Origin value in KA header.
  //
  // Bundle id and Android keyhash for iOS and Android platform, respectively.
  /// @nodoc
  static Future<String> get origin async {
    final String origin =
        await _channel.invokeMethod(CommonConstants.getOrigin);
    return origin;
  }

  /// KO: KA 헤더 정보
  /// <br>
  /// EN: KA header information
  static Future<String> get kaHeader async {
    final String kaHeader =
        await _channel.invokeMethod(CommonConstants.getKaHeader);
    return "sdk/$sdkVersion sdk_type/flutter $kaHeader";
  }

  /// @nodoc
  static Future<String> get appVer async {
    return await _channel.invokeMethod(CommonConstants.appVer);
  }

  /// @nodoc
  static Future<String> get packageName async {
    return await _channel.invokeMethod(CommonConstants.packageName);
  }

  /// KO: 리다이렉트 URI
  /// <br>
  /// EN: Redirect URI
  static String get redirectUri => "$customScheme://oauth";

  static late String _customScheme;

  /// @nodoc
  static String get customScheme => _customScheme;

  /// KO: Kakao SDK 초기화<br>
  /// 앱별 커스텀 URL 스킴은 [customScheme]으로 등록<br>
  /// [loggingEnabled]로 Kakao SDK 내부 로그 기능 활성화 여부 설정<br>
  /// <br>
  /// EN: Initializes Kakao SDK<br>
  /// Register custom URL scheme for each app as [customScheme]<br>
  /// Set Whether to enable the internal log of the Kakao SDK with [loggingEnabled]
  static void init({
    String? nativeAppKey,
    String? javaScriptAppKey,
    String? customScheme,
    ServerHosts? serviceHosts,
    PlatformSupport? platformSupport,
    bool? loggingEnabled,
  }) {
    if (nativeAppKey == null && javaScriptAppKey == null) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        "A Native App Key or JavaScript App Key is required",
      );
    }

    _nativeKey = nativeAppKey ?? "";
    _jsKey = javaScriptAppKey ?? "";
    _customScheme = customScheme ?? "kakao$appKey";
    hosts = serviceHosts ?? ServerHosts();
    platforms = platformSupport ?? PlatformSupport();
    logging = loggingEnabled ?? false;
  }
}
