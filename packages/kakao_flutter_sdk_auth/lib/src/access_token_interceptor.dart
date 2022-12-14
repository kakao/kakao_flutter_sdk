import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// @nodoc
/// API 요청에 AccessToken을 추가하는 인터셉터
/// -401 발생시 자동 갱신
class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor(this._dio, this._kauthApi,
      {TokenManagerProvider? tokenManagerProvider})
      : _tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  final Dio _dio;
  final AuthApi _kauthApi;
  final TokenManagerProvider _tokenManagerProvider;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenManagerProvider.manager.getToken();

    if (token == null) {
      handler.reject(
        DioError(
            requestOptions: options,
            error: "authentication tokens don't exist."),
      );
      return;
    }

    options.headers[CommonConstants.authorization] =
        "${CommonConstants.bearer} ${token.accessToken}";
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kIsWeb) {
      handler.next(err);
      return;
    }

    final options = err.response?.requestOptions;
    final request = err.requestOptions;
    final token = await _tokenManagerProvider.manager.getToken();

    if (!_isTokenError(err) || options == null || token == null) {
      handler.next(err);
      return;
    }

    try {
      if (request.headers[CommonConstants.authorization] !=
          "${CommonConstants.bearer} ${token.accessToken}") {
        // tokens were refreshed by another API request.
        SdkLog.i(
            "just retry ${options.path} since access token was already refreshed by another request.");

        var response = await _dio.fetch(options);
        handler.resolve(response);
        return;
      }

      _dio.lock();
      _dio.interceptors.errorLock.lock();

      final newToken = await _kauthApi.refreshToken(oldToken: token);
      options.headers[CommonConstants.authorization] =
          "${CommonConstants.bearer} ${newToken.accessToken}";

      _dio.unlock();
      _dio.interceptors.errorLock.unlock();

      SdkLog.i("retry ${options.path} after refreshing access token.");
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

  bool _isTokenError(Object err) {
    if (err is DioError) {
      if (err.requestOptions.baseUrl ==
              "${CommonConstants.scheme}://${KakaoSdk.hosts.kapi}" &&
          err.response != null &&
          err.response?.data != null) {
        var kapiException = KakaoApiException.fromJson(err.response?.data!);

        if (kapiException.code == ApiErrorCause.invalidToken) {
          return true;
        }
      }

      if (err.requestOptions.baseUrl ==
          "${CommonConstants.scheme}://${KakaoSdk.hosts.kauth}") {
        return true;
      }
    }
    return false;
  }
}
