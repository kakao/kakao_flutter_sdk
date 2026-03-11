import 'package:kakao_flutter_sdk_auth/src/auth_platform.dart';
import 'package:kakao_flutter_sdk_auth/src/model/pkce.dart';
import 'package:kakao_flutter_sdk_auth/src/model/prompt.dart';

class FakeAuthPlatform implements AuthPlatform {
  Map<String, String> mockPlatformData = {'platform': 'test'};
  String mockRedirectUri = 'kakao://oauth';
  String? newScopesAuthCode;
  Exception? newScopesError;
  int authorizeWithNewScopesCallCount = 0;

  // Track last call parameters
  String? lastRedirectUri;
  List<String>? lastScopes;
  String? lastAgt;
  List<Prompt>? lastPrompts;
  String? lastLoginHint;
  String? lastNonce;
  List<String>? lastChannelPublicIds;
  List<String>? lastServiceTerms;

  @override
  Map<String, String> getPlatformData() => mockPlatformData;

  @override
  Future<String> authorizeWithTalk(
    String redirectUri,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) async {
    lastRedirectUri = redirectUri;
    lastNonce = nonce;
    lastChannelPublicIds = channelPublicIds;
    lastServiceTerms = serviceTerms;
    return 'auth_code_from_talk';
  }

  @override
  Future<String> authorize(
    String redirectUri,
    List<Prompt>? prompts,
    String? loginHint,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) async {
    lastRedirectUri = redirectUri;
    lastPrompts = prompts;
    lastLoginHint = loginHint;
    lastNonce = nonce;
    lastChannelPublicIds = channelPublicIds;
    lastServiceTerms = serviceTerms;
    return 'auth_code';
  }

  @override
  Future<String> authorizeWithNewScopes(
    String agt,
    String redirectUri,
    List<String> scopes,
    PKCE? pkce,
    String? nonce,
  ) async {
    authorizeWithNewScopesCallCount++;
    lastAgt = agt;
    lastRedirectUri = redirectUri;
    lastScopes = scopes;
    lastNonce = nonce;
    if (newScopesError != null) {
      throw newScopesError!;
    }
    return newScopesAuthCode ?? 'auth_code_with_new_scopes';
  }

  @override
  Future<String> handleAppsUrl(
    String url, {
    String transId = '',
    String popupTitle = '',
  }) async {
    return 'handled_url';
  }
}
