import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../auth_api.dart';
import '../constants.dart';
import '../model/oauth_token.dart';
import '../token_manager.dart';

/// @nodoc
// API 요청에 AccessToken을 추가하는 인터셉터. -401 발생시 자동 갱신
class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor(
    this._dio, {
    AuthApi? authApi,
    TokenManager? tokenManager,
  }) : _authApi = authApi ?? AuthApi.instance,
       _tokenManager = tokenManager ?? TokenManagerProvider.instance.manager;

  final Dio _dio;
  final AuthApi _authApi;
  final TokenManager _tokenManager;
  static const String _refreshRetriedKey = 'kakao_refresh_retried';

  Future<OAuthToken>? _tokenRefreshLock;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (!options.headers.containsKey(Constants.authorization)) {
        final accessToken = await _getAccessToken();
        options.headers[Constants.authorization] =
            '${Constants.bearer} $accessToken';
      }

      handler.next(options);
    } on DioException catch (error) {
      handler.reject(error);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Web 환경에서는 토큰 갱신을 지원 x
    if (kIsWeb) {
      handler.next(err);
      return;
    }

    if (!_canRetryAfterRefresh(err)) {
      handler.next(err);
      return;
    }

    try {
      final response = await _retryAfterRefresh(err);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.reject(error);
    }
  }

  Future<String> _getAccessToken() async {
    final token = await _tokenManager.getToken();

    if (token == null) {
      throw DioException(
        requestOptions: RequestOptions(),
        message: "authentication token doesn't exist.",
      );
    }

    return token.accessToken;
  }

  bool _canRetryAfterRefresh(DioException error) {
    if (error.requestOptions.extra[_refreshRetriedKey] == true) {
      return false;
    }

    final hasResponse = error.response?.requestOptions != null;
    final isTokenError = _isTokenError(error);

    return hasResponse && isTokenError;
  }

  Future<Response> _retryAfterRefresh(DioException error) async {
    final originalRequest = error.response!.requestOptions;

    if (_tokenRefreshLock != null) {
      SdkLog.w(
        '[AccessTokenInterceptor.retryAfterRefresh] waiting | path=${originalRequest.path} reason=refresh_in_progress',
      );
      await _tokenRefreshLock!;
    }

    final currentToken = await _tokenManager.getToken();
    if (currentToken == null) {
      throw error;
    }

    // 다른 요청에 의해 이미 토큰이 갱신된 경우 바로 재시도
    if (_isTokenAlreadyRefreshed(error.requestOptions, currentToken)) {
      SdkLog.i(
        '[AccessTokenInterceptor.retryAfterRefresh] retrying | path=${originalRequest.path} reason=token_already_refreshed',
      );
      return _retryWithNewToken(originalRequest, currentToken);
    }

    // 토큰 갱신 후 재시도
    final newToken = await _refreshToken(currentToken);
    return await _retryWithNewToken(originalRequest, newToken);
  }

  bool _isTokenAlreadyRefreshed(
    RequestOptions request,
    OAuthToken currentToken,
  ) {
    final requestAuthHeader = request.headers[Constants.authorization];
    final currentAuthHeader = '${Constants.bearer} ${currentToken.accessToken}';

    return requestAuthHeader != currentAuthHeader;
  }

  Future<OAuthToken> _refreshToken(OAuthToken oldToken) async {
    // 이미 진행 중인 토큰 갱신이 있으면 대기
    if (_tokenRefreshLock != null) {
      SdkLog.w(
        '[AccessTokenInterceptor.refreshToken] waiting | reason=refresh_in_progress',
      );
      return await _tokenRefreshLock!;
    }

    try {
      SdkLog.d('[AccessTokenInterceptor.refreshToken] started');
      _tokenRefreshLock = _authApi.refreshToken(oldToken: oldToken);
      final newToken = await _tokenRefreshLock!;
      await _tokenManager.setToken(newToken);

      SdkLog.i(
        '[AccessTokenInterceptor.refreshToken] completed | expiresAt=${newToken.expiresAt.toIso8601String()}',
      );
      return newToken;
    } catch (error) {
      SdkLog.e(
        '[AccessTokenInterceptor.refreshToken] failed | action=clear_token',
      );
      await _tokenManager.clear();
      rethrow;
    } finally {
      _tokenRefreshLock = null;
    }
  }

  Future<Response> _retryWithNewToken(
    RequestOptions originalRequest,
    OAuthToken newToken,
  ) async {
    final updatedHeaders = {
      ...originalRequest.headers,
      Constants.authorization: '${Constants.bearer} ${newToken.accessToken}',
    };

    final retryRequest = originalRequest.copyWith(headers: updatedHeaders);
    retryRequest.extra[_refreshRetriedKey] = true;

    SdkLog.i(
      '[AccessTokenInterceptor.retryWithNewToken] retrying | path=${retryRequest.path}',
    );

    try {
      return await _dio.fetch(retryRequest);
    } on Exception catch (error) {
      // 재시도 후에도 토큰 에러가 발생하면 토큰 삭제
      if (_isTokenError(error)) {
        SdkLog.e(
          '[AccessTokenInterceptor.retryWithNewToken] failed | path=${retryRequest.path} reason=token_error_persisted action=clear_token',
        );
        await _tokenManager.clear();
      }
      rethrow;
    }
  }

  bool _isTokenError(Exception exception) {
    return _isKapiInvalidTokenError(exception) || _isKauthError(exception);
  }

  bool _isKauthError(Exception exception) {
    if (exception is! DioException) {
      return false;
    }

    final kauthBaseUrl = 'https://${KakaoSdk.hosts.kauth}';
    return exception.requestOptions.baseUrl == kauthBaseUrl;
  }

  bool _isKapiInvalidTokenError(Exception exception) {
    if (exception is! DioException) {
      return false;
    }

    if (exception.requestOptions.baseUrl != 'https://${KakaoSdk.hosts.kapi}') {
      return false;
    }

    final errorData = exception.response?.data;
    if (errorData == null) {
      return false;
    }

    try {
      final kapiException = KakaoApiException.fromJson(errorData);
      return kapiException.code == ApiErrorCause.invalidToken;
    } catch (_) {
      return false;
    }
  }
}
