import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/src/constants.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_api_exception.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_auth_exception.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';
import 'package:kakao_flutter_sdk_common/src/sdk_log.dart';

/// @nodoc
// Factory for network clients, interceptors, and error transformers used by other libraries
class ApiFactory {
  // Dio instance for appkey-based Kakao API.
  static final Dio appKeyApi = _appKeyApiInstance();

  static Dio _appKeyApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "${CommonConstants.scheme}://${KakaoSdk.hosts.kapi}";
    dio.options.contentType = CommonConstants.contentType;
    dio.interceptors.addAll([
      appKeyInterceptor,
      kaInterceptor,
      LogInterceptor(
        requestBody: kDebugMode ? true : false,
        responseBody: kDebugMode ? true : false,
        logPrint: SdkLog.i,
      )
    ]);
    return dio;
  }

  static Future<T> handleApiError<T>(
      Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioException catch (e) {
      throw transformApiError(e);
    }
  }

  /// transforms [DioException] to [KakaoException].
  static Exception transformApiError(DioException e) {
    var response = e.response;
    var request = e.requestOptions;

    // interceptor reject the error when the error cannot be handled
    // but the error must be DioError, so the error received from the server cannot be transmitted as it is.
    // so the error received from the server is put in the DioError.error
    if (response == null) {
      if (e.error != null) {
        if (e.error is KakaoAuthException) {
          return e.error as KakaoAuthException;
        }
        if (e.error is KakaoApiException) {
          return e.error as KakaoApiException;
        }
        // If the user closes the default browser when the RequiredScopeInterceptor brings up the additional consent page,
        // The PlatformException is thrown.
        if (e.error is PlatformException) {
          return e.error as PlatformException;
        }
      }
      return KakaoClientException(
        ClientErrorCause.unknown,
        e.message ?? "Unknown",
      );
    }
    if (response.statusCode == 404) {
      return KakaoClientException(
        ClientErrorCause.notSupported,
        e.message ?? "404 Not Found",
      );
    }
    if (Uri.parse(request.baseUrl).host == KakaoSdk.hosts.kauth) {
      return KakaoAuthException.fromJson(response.data);
    }

    return KakaoApiException.fromJson(response.data);
  }

  // DIO interceptor for App-key based API (Link etc).
  static Interceptor appKeyInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[CommonConstants.authorization] =
        "${CommonConstants.kakaoAk} ${KakaoSdk.appKey}";
    handler.next(options);
  });

  // DIO interceptor for all Kakao API that requires KA header
  static Interceptor kaInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    var kaHeader = await KakaoSdk.kaHeader;
    options.headers[CommonConstants.ka] = kaHeader;
    handler.next(options);
  });
}
