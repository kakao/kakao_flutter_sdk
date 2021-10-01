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
      {TokenManagerProvider? tokenManagerProvider})
      : this._tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  Dio _dio;
  AuthApi _kauthApi;
  TokenManagerProvider _tokenManagerProvider;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenManagerProvider.manager.getToken();
    options.headers["Authorization"] = "Bearer ${token?.accessToken}";
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final options = err.response?.requestOptions;
    final request = err.requestOptions;
    final token = await _tokenManagerProvider.manager.getToken();

    if (!isRetryable(err) || options == null || token == null) {
      handler.next(err);
      return;
    }

    try {
      if (request.headers["Authorization"] != "Bearer ${token.accessToken}") {
        // tokens were refreshed by another API request.
        print(
            "just retry ${options.path} since access token was already refreshed by another request.");

        var response = await _dio.fetch(options);
        handler.resolve(response);
        return;
      }

      _dio.lock();
      _dio.interceptors.errorLock.lock();

      final newToken = await _kauthApi.refreshAccessToken(token);
      options.headers["Authorization"] = "Bearer ${newToken.accessToken}";

      _dio.unlock();
      _dio.interceptors.errorLock.unlock();

      print("retry ${options.path} after refreshing access token.");
      var response = await _dio.fetch(options);
      handler.resolve(response);
    } catch (error) {
      if (_isTokenError(error)) {
        await _tokenManagerProvider.manager.clear();
      }
      if (error is DioError) {
        handler.reject(error);
      } else {
        handler.reject(DioError(requestOptions: options, error: error));
      }
    } finally {
      // The lock must be unlocked because errors may occur while the lock is locked.
      _dio.unlock();
      _dio.interceptors.errorLock.unlock();
    }
  }

  /// This can be overridden
  bool isRetryable(DioError err) =>
      err.requestOptions.baseUrl == "https://${KakaoContext.hosts.kapi}" &&
      err.response != null &&
      err.response?.statusCode == 401;

  bool _isTokenError(Object err) {
    if (err is KakaoAuthException ||
        err is KakaoApiException && err.code == ApiErrorCause.INVALID_TOKEN) {
      return true;
    }
    return false;
  }
}
