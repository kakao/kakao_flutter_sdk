import 'package:dio/dio.dart';

import '../kakao_sdk.dart';
import '../model/kakao_api_exception.dart';
import '../model/kakao_auth_exception.dart';
import '../model/kakao_client_exception.dart';
import 'kakao_http_client.dart';

/// @nodoc
class KakaoDioHttpClient implements KakaoHttpClient {
  final Dio _dio;
  final List<Interceptor> interceptors;

  KakaoDioHttpClient({
    Dio? dio,
    BaseOptions? options,
    this.interceptors = const [],
  }) : _dio = (dio ?? Dio(options))..interceptors.addAll(interceptors);

  @override
  Future<KakaoResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _toKakaoResponse(response);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<KakaoResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _toKakaoResponse(response);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<KakaoResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _toKakaoResponse(response);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<KakaoResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _toKakaoResponse(response);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  KakaoResponse _toKakaoResponse(Response response) {
    return KakaoResponse(
      statusCode: response.statusCode ?? 0,
      data: response.data,
      headers: response.headers.map,
    );
  }

  static Exception handleDioError(DioException e) {
    final request = e.requestOptions;
    final response = e.response;

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

        if (e.error is Exception) {
          return e.error as Exception;
        }
      }

      return KakaoClientException(
        ClientErrorCause.unknown,
        e.message ?? 'Unknown',
      );
    }

    if (response.statusCode == 404) {
      return KakaoClientException(
        ClientErrorCause.notSupported,
        e.message ?? '404 Not Found',
      );
    }

    if (Uri.parse(request.baseUrl).host == KakaoSdk.hosts.kauth) {
      return KakaoAuthException.fromJson(response.data);
    }

    return KakaoApiException.fromJson(response.data);
  }
}
