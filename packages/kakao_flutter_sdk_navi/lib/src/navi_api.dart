import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_navi/src/constants.dart';
import 'package:kakao_flutter_sdk_navi/src/model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk_navi/src/model/location.dart';
import 'package:kakao_flutter_sdk_navi/src/model/navi_option.dart';
import 'package:platform/platform.dart';

/// KO: 카카오내비 API 클라이언트
/// <br>
/// EN: Client for the Kakao Navi APIs
class NaviApi {
  final Platform _platform;
  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  static String get webNaviInstall {
    var platform = const LocalPlatform();
    if (kIsWeb) {
      return KakaoSdk.platforms.web.kakaoNaviInstallPage;
    } else if (platform.isIOS) {
      return KakaoSdk.platforms.ios.kakaoNaviInstallPage;
    } else {
      return KakaoSdk.platforms.android.kakaoNaviInstallPage;
    }
  }

  static final NaviApi instance = NaviApi();

  /// @nodoc
  NaviApi({Platform? platform}) : _platform = platform ?? const LocalPlatform();

  /// KO: 카카오내비 앱 실행 가능 여부 조회
  /// <br>
  /// EN: Check whether the Kakao Navi app is available
  Future<bool> isKakaoNaviInstalled() async {
    Map<String, String> arguments = {};
    if (kIsWeb) {
    } else if (_platform.isAndroid) {
      arguments.addAll(
          {Constants.naviOrigin: KakaoSdk.platforms.android.kakaoNaviOrigin});
    } else {
      arguments.addAll(
          {Constants.naviOrigin: KakaoSdk.platforms.ios.kakaoNaviScheme});
    }

    final isInstalled = await _channel.invokeMethod<bool>(
            CommonConstants.isKakaoNaviInstalled, arguments) ??
        false;
    return isInstalled;
  }

  /// KO: 카카오내비 앱으로 길안내 실행, 모바일 기기에서만 동작<br>
  /// [destination]에 목적지 전달<br>
  /// [option]에 경로 검색 옵션 전달<br>
  /// [viaList]에 경유지 목록 전달(최대: 3개)<br>
  /// <br>
  /// EN: Launches the Kakao Navi app to start navigation, available only on the mobile devices<br>
  /// Pass the destination to [destination]<br>
  /// Pass the options for searching the route to [option]<br>
  /// Pass the list of stops to [viaList] (Maximum: 3 places)
  Future navigate(
      {required Location destination,
      NaviOption? option,
      List<Location>? viaList}) async {
    String naviScheme = _getKakaoNaviScheme();
    final extras = await _getExtras();
    final arguments = {
      Constants.naviScheme: naviScheme,
      Constants.appKey: KakaoSdk.appKey,
      Constants.extras: jsonEncode(extras),
      Constants.naviParams: jsonEncode(
        KakaoNaviParams(
          destination: destination,
          option: option,
          viaList: viaList,
        ),
      )
    };
    await _channel.invokeMethod<bool>(CommonConstants.navigate, arguments);
  }

  /// KO: 카카오내비 앱으로 목적지 공유 실행, 모바일 기기에서만 동작<br>
  /// [destination]에 목적지 전달<br>
  /// [option]에 경로 검색 옵션 전달<br>
  /// [viaList]에 경유지 목록 전달(최대: 3개)<br>
  /// <br>
  /// EN: Launches the Kakao Navi app to show the shared destination, available only on the mobile devices<br>
  /// Pass the destination to [destination]<br>
  /// Pass the options for searching the route to [option]<br>
  /// Pass the list of stops to [viaList] (Maximum: 3 places)
  Future shareDestination(
      {required Location destination,
      NaviOption? option,
      List<Location>? viaList}) async {
    final shareNaviOption = NaviOption(
        coordType: option?.coordType,
        vehicleType: option?.vehicleType,
        rpOption: option?.rpOption,
        routeInfo: true,
        startX: option?.startX,
        startY: option?.startY,
        startAngle: option?.startAngle);

    String naviScheme = _getKakaoNaviScheme();
    final extras = await _getExtras();
    final arguments = {
      Constants.naviScheme: naviScheme,
      Constants.appKey: KakaoSdk.appKey,
      Constants.extras: jsonEncode(extras),
      Constants.naviParams: jsonEncode(
        KakaoNaviParams(
          destination: destination,
          option: shareNaviOption,
          viaList: viaList,
        ),
      )
    };
    await _channel.invokeMethod<bool>(
        CommonConstants.shareDestination, arguments);
  }

  Future<Map<String, String>> _getExtras() async {
    var platformInfo = kIsWeb
        ? {}
        : _platform.isAndroid
            ? {
                Constants.appPkg: await KakaoSdk.packageName,
                Constants.keyHash: await KakaoSdk.origin
              }
            : _platform.isIOS
                ? {Constants.appPkg: await KakaoSdk.origin}
                : {};

    return {Constants.ka: await KakaoSdk.kaHeader, ...platformInfo};
  }

  String _getKakaoNaviScheme() {
    PlatformSupportValues platform;
    if (kIsWeb) {
      platform = KakaoSdk.platforms.web;
    } else if (_platform.isAndroid) {
      platform = KakaoSdk.platforms.android;
    } else {
      platform = KakaoSdk.platforms.ios;
    }
    return platform.kakaoNaviScheme;
  }
}
