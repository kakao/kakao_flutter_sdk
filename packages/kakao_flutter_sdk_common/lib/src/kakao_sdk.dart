import 'package:flutter/foundation.dart';

import 'common_platform.dart';
import 'model/kakao_client_exception.dart';
import 'model/platform_info.dart';
import 'platform_support.dart';
import 'sdk_log.dart';
import 'server_hosts.dart';

/// KO: 주요 설정 및 초기화 클래스
/// <br>
/// EN: Class for major settings and initializing
class KakaoSdk {
  KakaoSdk._();

  /// @nodoc
  static String sdkVersion = '2.0.0';
  static late String _nativeKey;
  static late String _jsKey;

  /// @nodoc
  static String get appKey => kIsWeb ? _jsKey : _nativeKey;

  /// @nodoc
  static bool logging = false;

  /// @nodoc
  static String get customScheme => _customScheme;
  static late String _customScheme;

  /// @nodoc
  static String get redirectUri => '$customScheme://oauth';

  /// @nodoc
  static late ServerHosts hosts;

  /// @nodoc
  static late PlatformInfo platformInfo;

  /// @nodoc
  static late PlatformSupport platform;

  /// KO: Kakao SDK 초기화<br>
  /// 앱별 커스텀 URL 스킴은 [customScheme]으로 등록<br>
  /// [loggingEnabled]로 Kakao SDK 내부 로그 기능 활성화 여부 설정<br>
  /// <br>
  /// EN: Initializes Kakao SDK<br>
  /// Register custom URL scheme for each app as [customScheme]<br>
  /// Set Whether to enable the internal log of the Kakao SDK with [loggingEnabled]
  static Future<void> init({
    String? nativeAppKey,
    String? javaScriptAppKey,
    String? customScheme,
    bool? loggingEnabled,
    ServerHosts? serviceHosts,
    PlatformSupport? platformSupport,
    CommonPlatform? platformProvider, // for testability
  }) async {
    if (nativeAppKey == null && javaScriptAppKey == null) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'A Native App Key or JavaScript App Key is required',
      );
    }

    _nativeKey = nativeAppKey ?? '';
    _jsKey = javaScriptAppKey ?? '';
    _customScheme = customScheme ?? 'kakao$appKey';
    logging = loggingEnabled ?? false;
    hosts = serviceHosts ?? ServerHosts();
    platform = platformSupport ?? DefaultPlatformSupport();

    platformInfo = await PlatformInfo.create(
      sdkVersion: sdkVersion,
      platform: platformProvider,
    );

    SdkLog.i(
      '[KakaoSdk.init] completed | loggingEnabled=$logging appKeyType=${kIsWeb ? 'javascript' : 'native'}',
    );
  }
}
