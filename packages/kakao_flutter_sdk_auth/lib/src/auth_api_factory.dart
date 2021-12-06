import 'package:kakao_flutter_sdk_auth/auth.dart';
import 'package:kakao_flutter_sdk_auth/src/access_token_interceptor.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/required_scopes_interceptor.dart';
import 'package:kakao_flutter_sdk_common/common.dart';

class AuthApiFactory {
  /// [Dio] instance for Kakao OAuth server.
  static final Dio kauthApi = _kauthApiInstance();

  /// [Dio] instance for token-based Kakao API.
  static final Dio authApi = _authApiInstance();

  static Dio _kauthApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kauth}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    dio.interceptors.addAll([ApiFactory.kaInterceptor]);
    return dio;
  }

  static Dio _authApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kapi}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    var tokenInterceptor = AccessTokenInterceptor(dio, AuthApi.instance);
    var scopeInterceptor = RequiredScopesInterceptor(dio);
    dio.interceptors
        .addAll([tokenInterceptor, scopeInterceptor, ApiFactory.kaInterceptor]);
    return dio;
  }
}
