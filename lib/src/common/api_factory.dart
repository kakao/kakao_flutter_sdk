import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';

/// Factory for network clients, interceptors, and error transformers used by other libraries.
class ApiFactory {
  /// [Dio] instance for Kakao OAuth server.
  static final Dio kauthApi = _kauthApiInstance();

  /// [Dio] instance for token-based Kakao API.
  static final Dio authApi = _authApiInstance();

  /// [Dio] instance for appkey-based Kakao API.
  static final Dio appKeyApi = _appKeyApiInstance();

  static Dio _kauthApiInstance() {
    var dio = new Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kauth}";
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    dio.interceptors.addAll([kaInterceptor]);
    return dio;
  }

  static Dio _authApiInstance() {
    var dio = new Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kapi}";
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var tokenInterceptor = AccessTokenInterceptor(dio, AuthApi.instance);
    dio.interceptors.addAll([tokenInterceptor, kaInterceptor]);
    return dio;
  }

  static Dio _appKeyApiInstance() {
    var dio = new Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kapi}";
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    dio.interceptors.addAll([appKeyInterceptor, kaInterceptor]);
    return dio;
  }

  static Future<T> handleApiError<T>(
      Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      throw transformApiError(e);
    }
  }

  /// transforms [DioError] to [KakaoException].
  ///
  static KakaoException transformApiError(DioError e) {
    if (e.response == null) return KakaoClientException(e.message);
    if (e.request.baseUrl == "https://${KakaoContext.hosts.kauth}") {
      return KakaoAuthException.fromJson(e.response.data);
    }
    return KakaoApiException.fromJson(e.response.data);
  }

  static Interceptor appKeyInterceptor =
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
    var appKey = KakaoContext.clientId;
    options.headers["Authorization"] = "KakaoAK $appKey";
    return options;
  });

  static Interceptor kaInterceptor =
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
    var kaHeader = await KakaoContext.kaHeader;
    options.headers["KA"] = kaHeader;
    return options;
  });
}
