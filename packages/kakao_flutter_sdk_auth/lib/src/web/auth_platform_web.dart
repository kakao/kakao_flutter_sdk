import 'dart:async';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:web/web.dart';

import '../auth_api.dart';
import '../auth_platform.dart';
import '../constants.dart';
import '../model/pkce.dart';
import '../model/prompt.dart';
import 'mobile.dart';

/// @nodoc
class AuthPlatformImpl extends AuthPlatform {
  @override
  Future<String> authorizeWithTalk(
    String redirectUri,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) async {
    if (!isMobileWeb()) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'Login with KakaoTalk is supported on mobile web platforms.',
      );
    }

    final stateToken = generateRandomString(20);

    if (isAndroidWeb()) {
      final intent = androidLoginIntent(
        redirectUri,
        stateToken,
        nonce,
        channelPublicIds,
        serviceTerms,
      );
      window.location.href = intent;
    } else {
      final universalLink = iosLoginUniversalLink(
        redirectUri,
        stateToken,
        nonce,
        channelPublicIds,
        serviceTerms,
      );

      window.location.href = universalLink;
    }

    final authCode = await _pollingAuthCode(stateToken);

    window.location.href =
        '$redirectUri?code=${Uri.encodeComponent(authCode)}&state=${Uri.encodeComponent(stateToken)}';
    return Future.value('');
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
  ) {
    final stateToken = generateRandomString(20);

    final params = <String, String>{
      Constants.clientId: KakaoSdk.appKey,
      Constants.redirectUri: redirectUri,
      Constants.responseType: Constants.code,
      Constants.channelPublicId: ?channelPublicIds?.join(','),
      Constants.serviceTerms: ?serviceTerms?.join(','),
      Constants.prompt: ?prompts?.map((e) => e.value).join(' '),
      Constants.loginHint: ?loginHint,
      Constants.codeChallenge: ?pkce?.codeChallenge,
      Constants.codeChallengeMethod: ?pkce?.codeChallengeMethod,
      Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
      Constants.nonce: ?nonce,
      Constants.state: stateToken,
      Constants.stateToken: stateToken,
      Constants.isPopup: false.toString(),
    };

    final url = Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.kauth,
      path: Constants.authorizePath,
      query: params.toQuery(),
    ).toString();

    window.location.href = url;
    return Future.value('');
  }

  @override
  Future<String> authorizeWithNewScopes(
    String agt,
    String redirectUri,
    List<String> scopes,
    PKCE? pkce,
    String? nonce,
  ) async {
    final stateToken = generateRandomString(20);

    final params = <String, String>{
      Constants.clientId: KakaoSdk.appKey,
      Constants.redirectUri: redirectUri,
      Constants.responseType: Constants.code,
      Constants.codeChallenge: ?pkce?.codeChallenge,
      Constants.codeChallengeMethod: ?pkce?.codeChallengeMethod,
      Constants.scope: scopes.join(' '),
      Constants.agt: agt,
      Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
      Constants.nonce: ?nonce,
      Constants.state: stateToken,
      Constants.stateToken: stateToken,
      Constants.isPopup: false.toString(),
    };

    final url = Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.kauth,
      path: Constants.authorizePath,
      query: params.toQuery(),
    ).toString();

    window.location.href = url;
    return Future.value('');
  }

  @override
  Map<String, String> getPlatformData() {
    return {Constants.clientOrigin: KakaoSdk.platformInfo.origin};
  }

  @override
  Future<String> handleAppsUrl(
    String url, {
    String transId = '',
    String popupTitle = '',
  }) {
    final userAgent = window.navigator.userAgent;
    final browser = BrowserDetector.detect(userAgent);

    final appsOrigin = 'https://${KakaoSdk.hosts.apps}';
    final iframe = createHiddenIframe(
      transId,
      '$appsOrigin/proxy?trans_id=$transId',
    );
    document.body?.append(iframe);

    final completer = Completer<String>();

    addMessageEventListener(
      browser,
      appsOrigin,
      completer,
      () => iframe.remove(),
    );

    window.open(
      url,
      popupTitle,
      'location=no,resizable=no,status=no,scrollbars=no,width=460,height=608',
    );
    return completer.future;
  }

  Future<String> _pollingAuthCode(
    String stateToken, {
    int count = 0,
    int maxCount = 600,
  }) async {
    final completer = Completer<String>();

    await Future.doWhile(() async {
      if (count == maxCount) {
        completer.completeError(
          TimeoutException('Kakao Login timed out. Please login again.'),
        );
        return false;
      }

      count++;
      await Future.delayed(const Duration(milliseconds: 1000));

      final response = await AuthApi.instance.codeForWeb(stateToken);

      if (response != 'error') {
        completer.complete(response);
        return false;
      }
      return true;
    });
    return completer.future;
  }
}
