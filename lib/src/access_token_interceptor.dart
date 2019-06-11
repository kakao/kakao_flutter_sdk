import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/auth/access_token_repo.dart';
import 'package:kakao_flutter_sdk/src/auth/auth_api.dart';

class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor(this.dio, this.kauthApi);

  Dio dio;
  AuthApi kauthApi;

  @override
  onRequest(RequestOptions options) async {
    var token = await AccessTokenRepo.instance.fromCache();
    options.headers["Authorization"] = "Bearer ${token.accessToken}";
    return options;
  }

  @override
  onError(DioError err) async {
    if (err.response == null || err.response.statusCode != 401) {
      return err;
    }
    dio.interceptors.requestLock.lock();
    var token = await AccessTokenRepo.instance.fromCache();
    try {
      var tokenResponse = await kauthApi.refreshAccessToken(token.refreshToken);
      await AccessTokenRepo.instance.toCache(tokenResponse);
      RequestOptions options = err.response.request;
      return dio.request(options.path, options: options);
    } finally {
      dio.interceptors.requestLock.unlock();
    }
  }
}
