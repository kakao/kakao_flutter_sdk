import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';

/// Automatically add consent in case of -402 error
class RequiredScopesInterceptor extends Interceptor {
  Dio _dio;
  AuthCodeClient _authCodeClient;
  AccessTokenStore _tokenStore;

  RequiredScopesInterceptor(this._dio, {AccessTokenStore? tokenStore})
      : this._authCodeClient = AuthCodeClient(),
        this._tokenStore = tokenStore ?? AccessTokenStore.instance;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var error = ApiFactory.transformApiError(err);
    if (!(error is KakaoApiException)) {
      handler.next(err);
      return;
    }
    var requiredScopes = error.requiredScopes;
    if (error.code == ApiErrorCause.INSUFFICIENT_SCOPE &&
        requiredScopes.isNotEmpty) {
      _dio.interceptors.errorLock.lock();
      _dio.interceptors.requestLock.lock();

      try {
        final authCode = await _authCodeClient.requestWithAgt(requiredScopes);
        final token = await AuthApi.instance.issueAccessToken(authCode);
        await _tokenStore.toStore(token);
      } catch (e) {
        handler.next(err);
        return;
      } finally {
        _dio.interceptors.requestLock.unlock();
        _dio.interceptors.errorLock.unlock();
      }
    } else if (error.code == ApiErrorCause.INSUFFICIENT_SCOPE &&
        requiredScopes.isEmpty) {
      throw KakaoApiException(ApiErrorCause.UNKNOWN, "requiredScopes not exist",
          error.apiType, error.requiredScopes, error.allowedScopes);
    }
    handler.next(err);
  }
}
