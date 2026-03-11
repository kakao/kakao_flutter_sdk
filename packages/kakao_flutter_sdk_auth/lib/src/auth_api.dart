import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'auth_platform.dart';
import 'constants.dart';
import 'model/access_token_response.dart';
import 'model/oauth_token.dart';
import 'network/kakao_auth_http_client_factory.dart';
import 'token_manager.dart';

/// KO: 카카오 로그인 인증 및 토큰 관리 클래스
/// <br>
/// EN: Class for the authentication and token management through Kakao Login
class AuthApi {
  /// @nodoc
  AuthApi({
    KakaoHttpClient? client,
    TokenManager? tokenManager,
    AuthPlatform? platform,
  }) : _client = client ?? KakaoAuthHttpClientFactory.kauthApi,
       _tokenManager = tokenManager ?? TokenManagerProvider.instance.manager,
       _platform = platform ?? AuthPlatform.instance;

  final KakaoHttpClient _client;
  final TokenManager _tokenManager;
  final AuthPlatform _platform;

  static final AuthApi instance = AuthApi();

  /// KO: 토큰 존재 여부 조회
  /// <br>
  /// EN: Check token presence
  Future<bool> hasToken() async {
    final token = await _tokenManager.getToken();
    SdkLog.d('[AuthApi.hasToken] completed | tokenExists=${token != null}');
    return token != null;
  }

  /// @nodoc
  Future<OAuthToken> issueAccessToken({
    required String authCode,
    required String redirectUri,
    required String codeVerifier,
  }) async {
    if (kIsWeb) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'This method is not supported on web platforms.',
      );
    }

    final platformData = _platform.getPlatformData();
    SdkLog.d(
      '[AuthApi.issueAccessToken] started | redirectUri=$redirectUri platformDataKeys=${platformData.keys.join(',')}',
    );
    final data = <String, String>{
      Constants.code: authCode,
      Constants.grantType: Constants.authorizationCode,
      Constants.clientId: KakaoSdk.appKey,
      Constants.redirectUri: redirectUri,
      Constants.codeVerifier: codeVerifier,
      ...platformData,
    };

    final token = await _issueAccessToken(data);
    SdkLog.i(
      '[AuthApi.issueAccessToken] completed | expiresAt=${token.expiresAt.toIso8601String()} hasRefreshToken=${token.refreshToken != null}',
    );
    return token;
  }

  /// @nodoc
  Future<OAuthToken> refreshToken({OAuthToken? oldToken}) async {
    final token = oldToken ?? await _tokenManager.getToken();

    if (token == null || token.refreshToken == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'Refresh token not found. You must login first.',
      );
    }

    SdkLog.d(
      '[AuthApi.refreshToken] started | source=${oldToken != null ? 'argument' : 'storage'} hasRefreshToken=${token.refreshToken != null}',
    );
    final data = <String, String>{
      Constants.refreshToken: token.refreshToken!,
      Constants.grantType: Constants.refreshToken,
      Constants.clientId: KakaoSdk.appKey,
      Constants.redirectUri: KakaoSdk.redirectUri,
      ..._platform.getPlatformData(),
    };

    final newToken = await _issueAccessToken(data, oldToken: oldToken);
    SdkLog.i(
      '[AuthApi.refreshToken] completed | expiresAt=${newToken.expiresAt.toIso8601String()} hasRefreshToken=${newToken.refreshToken != null}',
    );
    return newToken;
  }

  /// @nodoc
  Future<String> agt() async {
    final token = await _tokenManager.getToken();

    if (token == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'Token registered in TokenManager does not exist!',
      );
    }

    SdkLog.d('[AuthApi.agt] started');
    final data = <String, String>{
      Constants.clientId: KakaoSdk.appKey,
      Constants.accessToken: token.accessToken,
    };

    final response = await _client.post(Constants.agtPath, data: data);
    SdkLog.i('[AuthApi.agt] completed');
    return response.data[Constants.agt];
  }

  /// @nodoc
  Future<String> codeForWeb(String stateToken) async {
    SdkLog.d('[AuthApi.codeForWeb] started');
    final queryParams = <String, String>{
      Constants.clientId: KakaoSdk.appKey,
      Constants.authTranId: stateToken,
      Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
    };

    final response = await _client.get(
      Constants.apiWebCodeJson,
      queryParameters: queryParams,
    );

    if (response.data.toString().contains(Constants.error)) {
      SdkLog.w('[AuthApi.codeForWeb] failed | reason=error_response');
      return Constants.error;
    }
    SdkLog.i('[AuthApi.codeForWeb] completed');
    return response.data[Constants.code];
  }

  Future<OAuthToken> _issueAccessToken(
    Map<String, Object> data, {
    OAuthToken? oldToken,
  }) async {
    final response = await _client.post(Constants.tokenPath, data: data);
    final tokenResponse = AccessTokenResponse.fromJson(response.data);
    return OAuthToken.fromResponse(tokenResponse, oldToken: oldToken);
  }
}
