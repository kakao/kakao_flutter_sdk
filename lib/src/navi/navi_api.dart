import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/navi/model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk/src/navi/model/location.dart';
import 'package:kakao_flutter_sdk/src/navi/model/navi_option.dart';
import 'package:platform/platform.dart';

/// Provides KakaoTalk API.
class NaviApi {
  NaviApi(this._dio, {Platform? platform})
      : _platform = platform ?? LocalPlatform();

  final Dio _dio;
  final Platform _platform;
  final MethodChannel _channel = MethodChannel("kakao_flutter_sdk");
  static const String NAVI_HOSTS = "kakaonavi-wguide.kakao.com";

  /// Default instance SDK provides.
  static final NaviApi instance = NaviApi(ApiFactory.dapi);

  Future<bool> isKakaoNaviInstalled() async {
    final isInstalled =
        await _channel.invokeMethod<bool>("isKakaoNaviInstalled") ?? false;
    return isInstalled;
  }

  Future<Uri> navigateWebUrl(Location location,
      {NaviOption? option, List<Location>? viaList}) async {
    final naviParams =
        KakaoNaviParams(location, option: option, viaList: viaList);
    print('ios: ${_platform.isIOS}');
    final extras = {
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
    final params = {
      'param': jsonEncode(naviParams),
      'apiver': '1.0',
      'appkey': KakaoContext.clientId,
      'extras': jsonEncode(extras)
    };
    return Uri.https(NAVI_HOSTS, 'navigate.html', params);
  }
}
