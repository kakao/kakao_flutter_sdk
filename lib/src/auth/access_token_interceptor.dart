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
      {TokenManager? tokenManager})
      : this._tokenManager = tokenManager ?? TokenManager.instance;

  Dio _dio;
  AuthApi _kauthApi;
  TokenManager _tokenManager;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenManager.getToken();
    options.headers["Authorization"] = "Bearer ${token.accessToken}";
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    _dio.lock();
    if (!isRetryable(err)) {
      _dio.unlock();
      handler.next(err);
      return;
    }
    try {
      final options = err.response?.requestOptions;
      final request = err.requestOptions;
      final token = await _tokenManager.getToken();
      final refreshToken = token.refreshToken;
      if (options == null || refreshToken == null) {
        _dio.unlock();
        handler.next(err);
        return;
      }

      if (request.headers["Authorization"] != "Bearer ${token.accessToken}") {
        // tokens were refreshed by another API request.
        print(
            "just retry ${options.path} since access token was already refreshed by another request.");
        _dio
            .fetch(options)
            .then((response) => handler.resolve(response))
            .catchError((error, stackTrace) {
          handler.reject(error);
        }).whenComplete(() => _dio.unlock());
        return;
      }
      final tokenResponse = await _kauthApi.refreshAccessToken(refreshToken);
      var newToken = await _tokenManager.setToken(tokenResponse);
      print("retry ${options.path} after refreshing access token.");
      options.headers["Authorization"] = "Bearer ${newToken.accessToken}";
      _dio
          .fetch(options)
          .then((response) => handler.resolve(response))
          .catchError((error, stackTrace) {
        handler.reject(error);
      }).whenComplete(() => _dio.unlock());
    } catch (e) {
      if (e is KakaoAuthException ||
          e is KakaoApiException && e.code == ApiErrorCause.INVALID_TOKEN) {
        await _tokenManager.clear();
      }
      handler.next(err);
    } finally {
      _dio.unlock();
    }
  }

  /// This can be overridden
  bool isRetryable(DioError err) =>
      err.requestOptions.baseUrl == "https://${KakaoContext.hosts.kapi}" &&
      err.response != null &&
      err.response?.statusCode == 401;
}
