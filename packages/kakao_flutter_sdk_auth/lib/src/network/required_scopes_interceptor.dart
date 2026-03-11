import 'package:dio/dio.dart';

import '../../kakao_flutter_sdk_auth.dart';
import '../constants.dart';

/// @nodoc
// -402 에러 시 자동 추가 동의. Android, iOS 앱일 때만 동작
class RequiredScopesInterceptor extends Interceptor {
  RequiredScopesInterceptor(
    this._dio, {
    AuthCodeClient? authCodeClient,
    AuthApi? authApi,
    AuthPlatform? platform,
    TokenManager? tokenManager,
  }) : _authCodeClient = authCodeClient ?? AuthCodeClient.instance,
       _authApi = authApi ?? AuthApi.instance,
       _tokenManager = tokenManager ?? TokenManagerProvider.instance.manager;

  final Dio _dio;
  final AuthCodeClient _authCodeClient;
  final AuthApi _authApi;
  final TokenManager _tokenManager;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final apiError = KakaoDioHttpClient.handleDioError(err);

    if (!_shouldHandleError(apiError)) {
      handler.next(err);
      return;
    }

    final kakaoApiError = apiError as KakaoApiException;
    final requiredScopes = kakaoApiError.requiredScopes!;

    _validateRequiredScopes(requiredScopes, kakaoApiError);

    final options = err.response?.requestOptions;
    if (options == null) {
      handler.next(err);
      return;
    }

    await _handleInsufficientScope(
      options: options,
      requiredScopes: requiredScopes,
      handler: handler,
    );
  }

  bool _shouldHandleError(Exception error) {
    if (error is! KakaoApiException) return false;
    if (error.code != ApiErrorCause.insufficientScope) return false;
    if (error.requiredScopes == null) return false;
    return true;
  }

  void _validateRequiredScopes(
    List<String> requiredScopes,
    KakaoApiException originalError,
  ) {
    if (requiredScopes.isEmpty) {
      throw KakaoApiException(
        ApiErrorCause.unknown,
        'requiredScopes not exist',
        apiType: originalError.apiType,
        requiredScopes: originalError.requiredScopes,
        allowedScopes: originalError.allowedScopes,
      );
    }
  }

  Future<void> _handleInsufficientScope({
    required RequestOptions options,
    required List<String> requiredScopes,
    required ErrorInterceptorHandler handler,
  }) async {
    try {
      final newToken = await _requestAdditionalConsent(requiredScopes);
      await _retryRequestWithNewToken(options, newToken, handler);
    } on Exception catch (error) {
      _handleConsentError(error, options, handler);
    }
  }

  Future<OAuthToken> _requestAdditionalConsent(
    List<String> requiredScopes,
  ) async {
    final codeVerifier = generateRandomString(20);
    final redirectUri = KakaoSdk.redirectUri;

    // Get additional consents from user
    final authCode = await _authCodeClient.authorizeWithNewScopes(
      redirectUri: redirectUri,
      scopes: requiredScopes,
      codeVerifier: codeVerifier,
    );

    // Issue new access token with additional scopes
    final token = await _authApi.issueAccessToken(
      authCode: authCode,
      redirectUri: KakaoSdk.redirectUri,
      codeVerifier: codeVerifier,
    );

    await _tokenManager.setToken(token);
    return token;
  }

  Future<void> _retryRequestWithNewToken(
    RequestOptions options,
    OAuthToken newToken,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers[Constants.authorization] =
        '${Constants.bearer} ${newToken.accessToken}';

    final response = await _dio.fetch(options);
    handler.resolve(response);
  }

  void _handleConsentError(
    Exception error,
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) {
    if (error is DioException) {
      handler.reject(error);
    } else if (error is KakaoAuthException) {
      // KakaoAuthException is thrown when the 'Cancel' button is pressed
      // in the additional consent page
      handler.reject(DioException(requestOptions: options, error: error));
    } else {
      handler.next(DioException(requestOptions: options, error: error));
    }
  }
}
