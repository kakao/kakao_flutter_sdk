import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uri/uri.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/navi/model/location.dart';
import 'package:kakao_flutter_sdk/src/navi/model/navi_option.dart';
import 'package:kakao_flutter_sdk/src/navi/model/kakao_navi_params.dart';

/// Provides KakaoTalk API.
class NaviApi {
  NaviApi(this._dio);

  final Dio _dio;
  final MethodChannel _channel = MethodChannel("kakao_flutter_sdk");
  final String NAVI_HOSTS = "kakaonavi-wguide.kakao.com";

  /// Default instance SDK provides.
  static final NaviApi instance = NaviApi(ApiFactory.dapi);

  Future<bool> isKakaoNaviInstalled() async {
    final isInstalled =
        await _channel.invokeMethod<bool>("isKakaoNaviInstalled") ?? false;
    return isInstalled;
  }

  Future<Uri?> navigateWebUrl(Location location, NaviOption? option, List<Location>? viaList) async {

    final param = KakaoNaviParams(location, option, viaList);
    final extras = await _channel.invokeMethod<String>("getKaHeader");
    final builder = UriBuilder()
      ..scheme = 'https'
      ..host = NAVI_HOSTS
      ..port = 443
      ..path = 'navigate.html'
      ..queryParameters['param'] = param.toJson().toString()
      ..queryParameters['apiver'] = '1.0'
      ..queryParameters['appkey'] = KakaoContext.clientId
      ..queryParameters['extras'] = extras.toString();

    final naviUri = builder.build();
    return naviUri;
  }
}