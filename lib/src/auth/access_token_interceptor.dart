import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/src/auth/access_token_store.dart';
import 'package:kakao_flutter_sdk/src/auth/auth_api.dart';

/// Access token interceptor for Kakao API requests.
///
/// Mainly does two things:
///
/// 1. Adds Authorization header to every request. `Bearer ${access_token}`
/// 1. When access tokens are expired, retries API requests after refreshing access token.
///
class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor(this._dio, this._kauthApi,
      {AccessTokenStore tokenStore})
      : this._tokenStore = tokenStore ?? AccessTokenStore.instance;

  Dio _dio;
  AuthApi _kauthApi;
  AccessTokenStore _tokenStore;

  @override
  onRequest(RequestOptions options) async {
    final token = await _tokenStore.fromStore();
    options.headers["Authorization"] = "Bearer ${token.accessToken}";
    return options;
  }

  @override
  onError(DioError err) async {
    _dio.interceptors.errorLock.lock();
    if (!isRetryable(err)) {
      _dio.interceptors.errorLock.unlock();
      return err;
    }
    try {
      _dio.interceptors.requestLock.lock();
      RequestOptions options = err.response.request;
      final token = await _tokenStore.fromStore();
      if (err.request.headers["Authorization"] !=
          "Bearer ${token.accessToken}") {
        // tokens were refreshed by another API request.
        print(
            "just retry ${options.path} since access token was already refreshed by another request.");
        return _dio.request(options.path, options: options);
      }
      final tokenResponse =
          await _kauthApi.refreshAccessToken(token.refreshToken);
      await _tokenStore.toStore(tokenResponse);
      print("retry ${options.path} after refreshing access token.");
      return _dio.request(options.path, options: options);
    } catch (e) {
      if (e is KakaoAuthException ||
          e is KakaoApiException && e.code == ApiErrorCause.INVALID_TOKEN) {
        await _tokenStore.clear();
      }
      return err;
    } finally {
      _dio.interceptors.requestLock.unlock();
      _dio.interceptors.errorLock.unlock();
    }
  }

  /// This can be overridden
  bool isRetryable(DioError err) =>
      err.request.baseUrl == "https://${KakaoContext.hosts.kapi}" &&
      err.response != null &&
      err.response.statusCode == 401;
}
