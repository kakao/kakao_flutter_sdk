import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'auth_api.dart';
import 'auth_platform.dart';
import 'model/pkce.dart';
import 'model/prompt.dart';

/// KO: 카카오 로그인 인증 및 토큰 관리 클라이언트
/// <br>
/// EN: Client for the authentication and token management through Kakao Login
class AuthCodeClient {
  AuthCodeClient({AuthApi? api, AuthPlatform? platform})
    : _api = api ?? AuthApi.instance,
      _platform = platform ?? AuthPlatform.instance;

  final AuthApi _api;
  final AuthPlatform _platform;

  /// @nodoc
  static final AuthCodeClient instance = AuthCodeClient();

  /// KO: 카카오톡으로 로그인: 리다이렉트 방식
  /// <br>
  /// EN: Login with Kakao Talk through redirection
  Future<String> authorizeWithTalk({
    required String redirectUri,
    String? nonce,
    List<String>? channelPublicId,
    List<String>? serviceTerms,
    String? codeVerifier,
  }) async {
    SdkLog.d(
      '[AuthCodeClient.authorizeWithTalk] started | redirectUri=$redirectUri channelCount=${channelPublicId?.length ?? 0} serviceTermsCount=${serviceTerms?.length ?? 0} nonceProvided=${nonce != null}',
    );
    final code = await _platform.authorizeWithTalk(
      redirectUri,
      codeVerifier != null ? PKCE(codeVerifier) : null,
      nonce,
      channelPublicId,
      serviceTerms,
    );
    SdkLog.i('[AuthCodeClient.authorizeWithTalk] completed');
    return code;
  }

  /// KO: 카카오계정으로 로그인: 리다이렉트 방식
  /// <br>
  /// EN: Login with Kakao Account through redirection
  Future<String> authorize({
    required String redirectUri,
    List<Prompt>? prompts,
    String? loginHint,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? codeVerifier,
  }) async {
    SdkLog.d(
      '[AuthCodeClient.authorize] started | redirectUri=$redirectUri prompts=${prompts?.map((e) => e.name).join(',')} channelCount=${channelPublicIds?.length ?? 0} serviceTermsCount=${serviceTerms?.length ?? 0} loginHintProvided=${loginHint != null} nonceProvided=${nonce != null}',
    );
    final code = await _platform.authorize(
      redirectUri,
      prompts,
      loginHint,
      codeVerifier != null ? PKCE(codeVerifier) : null,
      nonce,
      channelPublicIds,
      serviceTerms,
    );
    SdkLog.i('[AuthCodeClient.authorize] completed');
    return code;
  }

  /// KO: 동의항목 추가 동의 요청
  /// <br>
  /// EN: Request additional consent
  Future<String> authorizeWithNewScopes({
    required String redirectUri,
    required List<String> scopes,
    String? nonce,
    String? codeVerifier,
  }) async {
    SdkLog.d(
      '[AuthCodeClient.authorizeWithNewScopes] started | redirectUri=$redirectUri scopeCount=${scopes.length} nonceProvided=${nonce != null}',
    );
    final agt = await _api.agt();

    final code = await _platform.authorizeWithNewScopes(
      agt,
      redirectUri,
      scopes,
      codeVerifier != null ? PKCE(codeVerifier) : null,
      nonce,
    );
    SdkLog.i('[AuthCodeClient.authorizeWithNewScopes] completed');
    return code;
  }
}
