import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';

/// Automatically add consent in case of -402 error
class RequiredScopesInterceptor extends Interceptor {
  Dio _dio;
  AuthCodeClient _authCodeClient;
  TokenManagerProvider _tokenManagerProvider;

  RequiredScopesInterceptor(this._dio,
      {TokenManagerProvider? tokenManagerProvider})
      : this._authCodeClient = AuthCodeClient.instance,
        this._tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var error = ApiFactory.transformApiError(err);
    if (!(error is KakaoApiException)) {
      handler.next(err);
      return;
    }

    var requiredScopes = error.requiredScopes;
    if (error.code == ApiErrorCause.INSUFFICIENT_SCOPE &&
        requiredScopes != null) {
      if (requiredScopes.isEmpty) {
        throw KakaoApiException(
            ApiErrorCause.UNKNOWN, "requiredScopes not exist",
            apiType: error.apiType,
            requiredScopes: error.requiredScopes,
            allowedScopes: error.allowedScopes);
      }

      var options = err.response?.requestOptions;

      if (options == null) {
        handler.next(err);
        return;
      }

      try {
        _dio.lock();
        _dio.interceptors.errorLock.lock();

        // get additional consents
        final authCode = await _authCodeClient.requestWithAgt(requiredScopes);
        final token = await AuthApi.instance.issueAccessToken(authCode);
        await _tokenManagerProvider.manager.setToken(token);
        options.headers["Authorization"] = "Bearer ${token.accessToken}";

        _dio.unlock();
        _dio.interceptors.errorLock.unlock();

        // after getting additional consents, retry api call
        var response = await _dio.fetch(options);
        handler.resolve(response);
      } catch (error) {
        if (error is DioError) {
          handler.reject(error);
        } else {
          handler.next(err);
        }
      } finally {
        _dio.unlock();
        _dio.interceptors.errorLock.unlock();
      }
    } else {
      handler.next(err);
    }
  }
}
