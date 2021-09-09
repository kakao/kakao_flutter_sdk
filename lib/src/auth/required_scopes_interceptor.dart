import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/auth.dart';

/// Automatically add consent in case of -402 error
class RequiredScopesInterceptor extends Interceptor {
  Dio _dio;
  AuthCodeClient _authCodeClient;
  TokenManager _tokenManager;

  RequiredScopesInterceptor(this._dio, {TokenManager? tokenManager})
      : this._authCodeClient = AuthCodeClient(),
        this._tokenManager = tokenManager ?? TokenManager.instance;

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
        requiredScopes != null &&
        requiredScopes.isNotEmpty) {
      _dio.lock();

      try {
        var options = err.response?.requestOptions;

        if (options == null) {
          _dio.unlock();
          handler.next(err);
          return;
        }

        final authCode = await _authCodeClient.requestWithAgt(requiredScopes);
        final token = await AuthApi.instance.issueAccessToken(authCode);
        var newToken = await _tokenManager.setToken(token);

        options.headers["Authorization"] = "Bearer ${newToken.accessToken}";

        _dio
            .fetch(options)
            .then((response) => handler.resolve(response))
            .catchError((error, stackTrace) {
          handler.reject(error);
        }).whenComplete(() => _dio.unlock());
      } catch (e) {
        handler.next(err);
      } finally {
        _dio.unlock();
      }
      return;
    } else if (error.code == ApiErrorCause.INSUFFICIENT_SCOPE &&
        requiredScopes != null &&
        requiredScopes.isEmpty) {
      throw KakaoApiException(ApiErrorCause.UNKNOWN, "requiredScopes not exist",
          apiType: error.apiType,
          requiredScopes: error.requiredScopes,
          allowedScopes: error.allowedScopes);
    }
    handler.next(err);
  }
}
