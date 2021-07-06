import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';


/// Provides KakaoTalk API.
class NaviApi {
  NaviApi(this._dio);

  final Dio _dio;
  final MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

  /// Default instance SDK provides.
  static final NaviApi instance = NaviApi(ApiFactory.dapi);

  Future<bool> isKakaoNaviInstalled() async {
    final isInstalled =
        await _channel.invokeMethod<bool>("isKakaoNaviInstalled") ?? false;
    return isInstalled;
  }

}