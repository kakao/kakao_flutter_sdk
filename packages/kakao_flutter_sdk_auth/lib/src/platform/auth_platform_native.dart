import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../auth_platform.dart';
import '../constants.dart';
import '../model/pkce.dart';
import '../model/prompt.dart';
import '../pigeon/auth_messages.g.dart';

/// @nodoc
class AuthPlatformImpl extends AuthPlatform {
  static final AuthHostApi _api = AuthHostApi();

  @override
  Future<String> authorizeWithTalk(
    String redirectUri,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) async {
    if (redirectUri != KakaoSdk.redirectUri) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'Redirect Login is not supported on native platforms.',
      );
    }

    final resultUrl = await _launchKakaoTalk(
      redirectUri,
      pkce,
      nonce,
      channelPublicIds,
      serviceTerms,
    );

    return _parseAuthCode(resultUrl);
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
    if (redirectUri != KakaoSdk.redirectUri) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'Redirect Login is not supported on native platforms.',
      );
    }

    final url = _createAuthorizeUrl(
      redirectUri,
      loginHint,
      prompts,
      pkce,
      nonce,
      channelPublicIds,
      serviceTerms,
    );

    SdkLog.v('[AuthPlatformImpl.authorize] request_url_created | url=$url');

    final resultUrl = await _api.authorize(url, redirectUri);

    return _parseAuthCode(resultUrl);
  }

  @override
  Future<String> authorizeWithNewScopes(
    String agt,
    String redirectUri,
    List<String> scopes,
    PKCE? pkce,
    String? nonce,
  ) async {
    if (redirectUri != KakaoSdk.redirectUri) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'Redirect Login is not supported on native platforms.',
      );
    }

    final url = _createAuthorizeUrl(
      redirectUri,
      null,
      null,
      pkce,
      nonce,
      null,
      null,
      newScopesParams: {Constants.agt: agt, Constants.scope: scopes.join(' ')},
    );

    SdkLog.v(
      '[AuthPlatformImpl.authorizeWithNewScopes] request_url_created | url=$url',
    );

    final resultUrl = await _api.authorize(url, redirectUri);

    return _parseAuthCode(resultUrl);
  }

  @override
  Map<String, String> getPlatformData() {
    if (KakaoSdk.platformInfo.isAndroid) {
      return {Constants.androidKeyHash: KakaoSdk.platformInfo.origin};
    }

    return {Constants.iosBundleId: KakaoSdk.platformInfo.origin};
  }

  @override
  Future<String> handleAppsUrl(
    String url, {
    String transId = '', // 웹 전용 파라미터
    String popupTitle = '', // 웹 전용 파라미터
  }) {
    return _api.launchAppsUrl(url);
  }

  Future<String> _launchKakaoTalk(
    String redirectUri,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) {
    return _api.authorizeWithKakaoTalk(
      KakaoSdk.appKey,
      KakaoSdk.redirectUri,
      KakaoSdk.platformInfo.kaHeader,
      _mapPkce(pkce),
      nonce,
      channelPublicIds,
      serviceTerms,
      KakaoSdk.platform.android.talkPackage,
      KakaoSdk.platform.ios.talkLoginScheme,
      KakaoSdk.platform.ios.iosLoginUniversalLink,
    );
  }

  PkceDto? _mapPkce(PKCE? pkce) {
    if (pkce == null) return null;
    return PkceDto(
      codeVerifier: pkce.codeVerifier,
      codeChallenge: pkce.codeChallenge,
      codeChallengeMethod: pkce.codeChallengeMethod,
    );
  }

  String _createAuthorizeUrl(
    String redirectUri,
    String? loginHint,
    List<Prompt>? prompts,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms, {
    Map<String, String> newScopesParams = const {}, // for scope updates
  }) {
    final params = <String, String>{
      Constants.clientId: KakaoSdk.appKey,
      Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
      Constants.responseType: Constants.code,
      Constants.redirectUri: redirectUri,
      Constants.loginHint: ?loginHint,
      Constants.prompt: ?prompts?.map((e) => e.value).join(' '),
      Constants.codeChallenge: ?pkce?.codeChallenge,
      Constants.codeChallengeMethod: ?pkce?.codeChallengeMethod,
      Constants.nonce: ?nonce,
      Constants.channelPublicId: ?channelPublicIds?.join(','),
      Constants.serviceTerms: ?serviceTerms?.join(','),
      ...newScopesParams,
    };

    return Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.kauth,
      path: Constants.authorizePath,
      query: params.toQuery(),
    ).toString();
  }

  String _parseAuthCode(String url) {
    final queryParams = Uri.parse(url).queryParameters;
    final code = queryParams[Constants.code];

    if (code != null) return code;

    throw KakaoAuthException.fromJson(queryParams);
  }
}
