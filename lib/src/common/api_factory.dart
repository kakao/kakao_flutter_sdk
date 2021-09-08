import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/src/auth/required_scopes_interceptor.dart';
import 'package:kakao_flutter_sdk/src/common/dapi_exception.dart';

/// Factory for network clients, interceptors, and error transformers used by other libraries.
class ApiFactory {
  /// [Dio] instance for Kakao OAuth server.
  static final Dio kauthApi = _kauthApiInstance();

  /// [Dio] instance for token-based Kakao API.
  static final Dio authApi = _authApiInstance();

  /// [Dio] instance for appkey-based Kakao API.
  static final Dio appKeyApi = _appKeyApiInstance();

  static final Dio dapi = _dapiInstance();

  static Dio _kauthApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kauth}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    dio.interceptors.addAll([kaInterceptor]);
    return dio;
  }

  static Dio _authApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kapi}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    var tokenInterceptor = AccessTokenInterceptor(dio, AuthApi.instance);
    var scopeInterceptor = RequiredScopesInterceptor(dio);
    dio.interceptors
        .addAll([tokenInterceptor, scopeInterceptor, kaInterceptor]);
    return dio;
  }

  static Dio _appKeyApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kapi}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    dio.interceptors.addAll([appKeyInterceptor, kaInterceptor]);
    return dio;
  }

  static Dio _dapiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.dapi}";
    dio.options.contentType = "application/x-www-form-urlencoded";
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
    var response = e.response;
    var request = e.requestOptions;

    if (response == null) return KakaoClientException(e.message);
    if (response.statusCode == 404) {
      return KakaoClientException(e.message);
    }
    if (Uri.parse(request.baseUrl).host == KakaoContext.hosts.kauth) {
      return KakaoAuthException.fromJson(response.data);
    }
    if (Uri.parse(request.baseUrl).host == KakaoContext.hosts.dapi) {
      return DapiException.fromJson(response.data);
    }

    return KakaoApiException.fromJson(response.data);
  }

  /// DIO interceptor for App-key based API (Link, Local, Search, etc).
  static Interceptor appKeyInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    var appKey = KakaoContext.clientId;
    options.headers["Authorization"] = "KakaoAK $appKey";
    handler.next(options);
  });

  /// DIO interceptor for all Kakao API that requires KA header.
  static Interceptor kaInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    var kaHeader = await KakaoContext.kaHeader;
    options.headers["KA"] = kaHeader;
    handler.next(options);
  });
}
