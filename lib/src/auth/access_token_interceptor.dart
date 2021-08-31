import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/src/auth/auth_api.dart';
import 'package:kakao_flutter_sdk/src/auth/token_manager.dart';

/// Access token interceptor for Kakao API requests.
///
/// Mainly does two things:
///
/// 1. Adds Authorization header to every request. `Bearer ${access_token}`
/// 1. When access tokens are expired, retries API requests after refreshing access token.
///
class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor(this._dio, this._kauthApi,
      {TokenManageable? tokenManager})
      : this._tokenManager = tokenManager ?? TokenManageable.instance;

  Dio _dio;
  AuthApi _kauthApi;
  TokenManageable _tokenManager;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenManager.getToken();
    options.headers["Authorization"] = "Bearer ${token.accessToken}";
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    _dio.interceptors.errorLock.lock();
    if (!isRetryable(err)) {
      _dio.interceptors.errorLock.unlock();
      handler.next(err);
      return;
    }
    try {
      _dio.interceptors.requestLock.lock();
      final options = err.response?.requestOptions;
      final request = err.requestOptions;
      final token = await _tokenManager.getToken();
      final refreshToken = token.refreshToken;
      if (options == null || refreshToken == null) {
        handler.next(err);
        return;
      }

      if (request.headers["Authorization"] != "Bearer ${token.accessToken}") {
        // tokens were refreshed by another API request.
        print(
            "just retry ${options.path} since access token was already refreshed by another request.");
        await _dio.fetch(options);
        return;
      }
      final tokenResponse = await _kauthApi.refreshAccessToken(refreshToken);
      await _tokenManager.setToken(tokenResponse);
      print("retry ${options.path} after refreshing access token.");
      await _dio.fetch(options);
      return;
    } catch (e) {
      if (e is KakaoAuthException ||
          e is KakaoApiException && e.code == ApiErrorCause.INVALID_TOKEN) {
        await _tokenManager.clear();
      }
      handler.next(err);
      return;
    } finally {
      _dio.interceptors.requestLock.unlock();
      _dio.interceptors.errorLock.unlock();
    }
  }

  /// This can be overridden
  bool isRetryable(DioError err) =>
      err.requestOptions.baseUrl == "https://${KakaoContext.hosts.kapi}" &&
      err.response != null &&
      err.response?.statusCode == 401;
}
