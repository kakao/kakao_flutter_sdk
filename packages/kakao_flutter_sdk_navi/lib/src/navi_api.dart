import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_navi/src/constants.dart';
import 'package:kakao_flutter_sdk_navi/src/model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk_navi/src/model/location.dart';
import 'package:kakao_flutter_sdk_navi/src/model/navi_option.dart';
import 'package:platform/platform.dart';

/// 카카오내비 API 호출을 담당하는 클래스
class NaviApi {
  NaviApi({Platform? platform}) : _platform = platform ?? const LocalPlatform();

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

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final NaviApi instance = NaviApi();

  /// 카카오내비 앱 실행 가능 여부 확인
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

  /// 카카오내비 앱으로 길안내를 실행
  /// [location]로 목적지를 입력받고 [option]를 통해 길안내 옵션을 입력받음
  /// 경유지 목록은 최대 3개까지 등록 가능하고 [viaList]로 입력받음
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

  /// 카카오내비 앱으로 목적지를 공유
  /// [location]로 목적지를 입력받고 [option]를 통해 길안내 옵션을 입력받음
  /// 경유지 목록은 최대 3개까지 등록 가능하고 [viaList]로 입력받음
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
