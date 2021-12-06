import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/common.dart';
import 'package:kakao_flutter_sdk_navi/src/model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk_navi/src/model/location.dart';
import 'package:kakao_flutter_sdk_navi/src/model/navi_option.dart';

/// 카카오내비 API 호출을 담당하는 클래스
class NaviApi {
  NaviApi({Platform? platform}) : _platform = platform ?? LocalPlatform();

  final Platform _platform;
  final MethodChannel _channel = MethodChannel("kakao_flutter_sdk");
  static const String NAVI_HOSTS = "kakaonavi-wguide.kakao.com";

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final NaviApi instance = NaviApi();

  /// 카카오내비 앱 설치 여부 검사.
  Future<bool> isKakaoNaviInstalled() async {
    final isInstalled =
        await _channel.invokeMethod<bool>("isKakaoNaviInstalled") ?? false;
    return isInstalled;
  }

  /// 웹 길안내 URL 반환.
  /// 획득한 URL을 브라우저에 요청하면 카카오내비 앱이 설치되지 않은 환경에서도 길안내 가능.
  /// [location]로 목적지를 입력받고 [option]를 통해 길안내 옵션을 입력받음.
  /// 경유지 목록은 최대 3개까지 등록 가능하고 [viaList]로 입력받음.
  Future<Uri> navigateWebUrl(Location location,
      {NaviOption? option, List<Location>? viaList}) async {
    final naviParams =
        KakaoNaviParams(location, option: option, viaList: viaList);
    final extras = await _getExtras();
    final params = {
      'param': jsonEncode(naviParams),
      'apiver': '1.0',
      'appkey': KakaoContext.clientId,
      'extras': jsonEncode(extras)
    };
    final url = Uri.https(NAVI_HOSTS, 'navigate.html', params);
    return Uri.parse(url.toString().replaceAll('+', '%20'));
  }

  /// 카카오내비 앱으로 길안내를 실행.
  /// [location]로 목적지를 입력받고 [option]를 통해 길안내 옵션을 입력받음.
  /// 경유지 목록은 최대 3개까지 등록 가능하고 [viaList]로 입력받음.
  Future navigate(
      {required Location destination,
      NaviOption? option,
      List<Location>? viaList}) async {
    final extras = await _getExtras();
    final arguments = {
      'app_key': KakaoContext.clientId,
      'extras': jsonEncode(extras),
      'navi_params': jsonEncode(
          KakaoNaviParams(destination, option: option, viaList: viaList))
    };
    await _channel.invokeMethod<bool>("navigate", arguments);
  }

  /// 카카오내비 앱으로 목적지를 공유.
  /// [location]로 목적지를 입력받고 [option]를 통해 길안내 옵션을 입력받음.
  /// 경유지 목록은 최대 3개까지 등록 가능하고 [viaList]로 입력받음.
  Future shareDestination(
      {required Location destination,
      NaviOption? option,
      List<Location>? viaList}) async {
    final extras = await _getExtras();
    final arguments = {
      'app_key': KakaoContext.clientId,
      'extras': jsonEncode(extras),
      'navi_params': jsonEncode(
          KakaoNaviParams(destination, option: option, viaList: viaList))
    };
    await _channel.invokeMethod<bool>("shareDestination", arguments);
  }

  Future<Map<String, String>> _getExtras() async {
    return {
      'KA': await KakaoContext.kaHeader,
      ...(_platform.isAndroid
          ? {
              "appPkg": await KakaoContext.packageName,
              "keyHash": await KakaoContext.origin
            }
          : _platform.isIOS
              ? {"appPkg": await KakaoContext.origin}
              : {})
    };
  }
}
