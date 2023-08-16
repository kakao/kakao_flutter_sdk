import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/src/access_token_interceptor.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/required_scopes_interceptor.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// @nodoc
class AuthApiFactory {
  // Dio instance for Kakao OAuth server.
  static final Dio kauthApi = _kauthApiInstance();

  // Dio instance for token-based Kakao API.
  static final Dio authApi = _authApiInstance();

  static Dio _kauthApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "${CommonConstants.scheme}://${KakaoSdk.hosts.kauth}";
    dio.options.contentType = CommonConstants.contentType;
    dio.interceptors.addAll([
      ApiFactory.kaInterceptor,
      LogInterceptor(
        logPrint: SdkLog.i,
        requestBody: kDebugMode ? true : false,
        responseBody: kDebugMode ? true : false,
      )
    ]);
    return dio;
  }

  static Dio _authApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "${CommonConstants.scheme}://${KakaoSdk.hosts.kapi}";
    dio.options.contentType = CommonConstants.contentType;

    var interceptors = [
      AccessTokenInterceptor(dio, AuthApi.instance),
      ApiFactory.kaInterceptor,
      LogInterceptor(
        logPrint: SdkLog.i,
        requestBody: kDebugMode ? true : false,
        responseBody: kDebugMode ? true : false,
      )
    ];
    if (!kIsWeb) {
      interceptors.add(RequiredScopesInterceptor(dio));
    }
    dio.interceptors.addAll(interceptors);
    return dio;
  }
}
