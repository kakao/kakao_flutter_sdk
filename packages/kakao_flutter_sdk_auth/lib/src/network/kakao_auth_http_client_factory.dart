import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'access_token_interceptor.dart';
import 'required_scopes_interceptor.dart';

/// @nodoc
class KakaoAuthHttpClientFactory {
  KakaoAuthHttpClientFactory._();

  static KakaoHttpClient get appKeyApi => KakaoHttpClientFactory.appKeyApi;

  // Kakao OAuth server.
  static KakaoHttpClient kauthApi = _createKAuthClient();

  // token-based Kakao API
  static KakaoHttpClient authApi = _createAuthClient();

  static KakaoHttpClient _createKAuthClient() {
    return KakaoDioHttpClient(
      options: BaseOptions(
        baseUrl: 'https://${KakaoSdk.hosts.kauth}',
        contentType: 'application/x-www-form-urlencoded',
        headers: {'KA': KakaoSdk.platformInfo.kaHeader},
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

  static KakaoHttpClient _createAuthClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://${KakaoSdk.hosts.kapi}',
        contentType: 'application/x-www-form-urlencoded',
        headers: {'KA': KakaoSdk.platformInfo.kaHeader},
      ),
    );

    final interceptors = <Interceptor>[AccessTokenInterceptor(dio)];

    if (!kIsWeb) interceptors.add(RequiredScopesInterceptor(dio));

    return KakaoDioHttpClient(
      dio: dio,
      interceptors: [
        ...interceptors,
        LogInterceptor(
          logPrint: SdkLog.i,
          requestBody: kDebugMode ? true : false,
          responseBody: kDebugMode ? true : false,
        ),
      ],
    );
  }
}
