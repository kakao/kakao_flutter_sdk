import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../kakao_sdk.dart';
import '../sdk_log.dart';
import 'kakao_dio_http_client.dart';
import 'kakao_http_client.dart';

/// @nodoc
class KakaoHttpClientFactory {
  KakaoHttpClientFactory._();

  static final KakaoHttpClient appKeyApi = _createAppKeyClient();

  static KakaoHttpClient _createAppKeyClient() {
    return KakaoDioHttpClient(
      options: BaseOptions(
        baseUrl: 'https://${KakaoSdk.hosts.kapi}',
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          'Authorization': 'KakaoAK ${KakaoSdk.appKey}',
          'KA': KakaoSdk.platformInfo.kaHeader,
        },
      ),
      interceptors: [
        LogInterceptor(
          logPrint: SdkLog.i,
          requestBody: kDebugMode ? true : false,
          responseBody: kDebugMode ? true : false,
        ),
      ],
    );
  }
}
