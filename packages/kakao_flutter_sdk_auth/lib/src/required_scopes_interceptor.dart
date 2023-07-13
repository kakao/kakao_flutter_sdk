import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

/// @nodoc
// -402 에러 시 자동 추가 동의
// Android, iOS 앱일 때만 동작
class RequiredScopesInterceptor extends Interceptor {
  final Dio _dio;
  final AuthCodeClient _authCodeClient;
  final TokenManagerProvider _tokenManagerProvider;

  RequiredScopesInterceptor(this._dio,
      {TokenManagerProvider? tokenManagerProvider})
      : _authCodeClient = AuthCodeClient.instance,
        _tokenManagerProvider =
            tokenManagerProvider ?? TokenManagerProvider.instance;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var error = ApiFactory.transformApiError(err);
    if (error is! KakaoApiException) {
      handler.next(err);
      return;
    }

    var requiredScopes = error.requiredScopes;

    if (error.code != ApiErrorCause.insufficientScope ||
        requiredScopes == null) {
      handler.next(err);
      return;
    }

    if (error.code == ApiErrorCause.insufficientScope) {
      if (requiredScopes.isEmpty) {
        throw KakaoApiException(
            ApiErrorCause.unknown, "requiredScopes not exist",
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
        // get additional consents
        final authCode = await _authCodeClient.authorizeWithNewScopes(
          redirectUri: KakaoSdk.redirectUri,
          scopes: requiredScopes,
        );
        final token =
            await AuthApi.instance.issueAccessToken(authCode: authCode);
        await _tokenManagerProvider.manager.setToken(token);
        options.headers[CommonConstants.authorization] =
            "${CommonConstants.bearer} ${token.accessToken}";

        // after getting additional consents, retry api call
        var response = await _dio.fetch(options);
        handler.resolve(response);
      } catch (error) {
        if (error is DioError) {
          handler.reject(error);
        } else if (error is KakaoAuthException) {
          // KakaoAuthException is thrown when the 'Cancel' button is pressed in the additional consent page
          handler.reject(DioError(requestOptions: options, error: error));
        } else {
          handler.next(DioError(requestOptions: options, error: error));
        }
      }
    }
  }
}
