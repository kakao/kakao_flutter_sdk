import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:platform/platform.dart';

const MethodChannel _channel = MethodChannel(CommonConstants.methodChannel);

/// KO: 카카오 로그인 인증 및 토큰 관리 클라이언트
/// <br>
/// EN: Client for the authentication and token management through Kakao Login
class AuthCodeClient {
  /// @nodoc
  AuthCodeClient({AuthApi? authApi}) : _kauthApi = authApi ?? AuthApi.instance;

  final AuthApi _kauthApi;
  final _platform = const LocalPlatform();

  static final AuthCodeClient instance = AuthCodeClient();

  /// KO: 카카오계정으로 로그인: 리다이렉트 방식
  /// <br>
  /// EN: Login with Kakao Account through redirection
  Future<String> authorize({
    String? clientId,
    required String redirectUri,
    List<String>? scopes,
    String? agt,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    List<Prompt>? prompts,
    String? loginHint,
    String? codeVerifier,
    String? nonce,
    String? kauthTxId,
    bool webPopupLogin = false,
  }) async {
    String? codeChallenge =
        codeVerifier != null ? _codeChallenge(codeVerifier) : null;
    final stateToken = generateRandomString(20);
    final kaHeader = await KakaoSdk.kaHeader;

    final params = await _makeAuthParams(
      clientId: clientId,
      redirectUri: redirectUri,
      scopes: scopes,
      agt: agt,
      channelPublicIds: channelPublicIds,
      serviceTerms: serviceTerms,
      prompts: prompts,
      loginHint: loginHint,
      codeChallenge: codeChallenge,
      nonce: nonce,
      kauthTxId: kauthTxId,
      stateToken: stateToken,
      isPopup: webPopupLogin,
    );
    final url = Uri.https(KakaoSdk.hosts.kauth, Constants.authorizePath, {
      ...params,
      Constants.isPopup: '$webPopupLogin',
    });
    SdkLog.i(url);

    try {
      if (kIsWeb && webPopupLogin) {
        final additionalParams = {};

        if (isiOS()) {
          additionalParams.addAll({
            ...params,
            'loginScheme': KakaoSdk.platforms.ios.talkLoginScheme,
            'universalLink': KakaoSdk.platforms.ios.iosLoginUniversalLink,
          });
        }

        await _channel.invokeMethod('popupLogin', {
          'url': url.toString(),
          ...additionalParams,
        });
        return _getAuthCode(stateToken, kaHeader);
      } else {
        final authCode = await _channel.invokeMethod('accountLogin', {
          CommonConstants.url: url.toString(),
          CommonConstants.redirectUri: redirectUri,

          // prevent popups from appearing on IOS.
          CommonConstants.authorizeNewScopes: scopes != null,
        });
        return _parseCode(authCode);
      }
    } catch (e) {
      SdkLog.e(e);
      rethrow;
    }
  }

  /// KO: 카카오톡으로 로그인: 리다이렉트 방식
  /// <br>
  /// EN: Login with Kakao Talk through redirection
  Future<String> authorizeWithTalk({
    String? clientId,
    required String redirectUri,
    List<Prompt>? prompts,
    List<String>? channelPublicId,
    List<String>? serviceTerms,
    String? codeVerifier,
    String? nonce,
    String? kauthTxId,
    String? stateToken,
    bool webPopupLogin = false,
  }) async {
    try {
      final webStateToken =
          stateToken ?? (kIsWeb ? generateRandomString(20) : null);

      var response = await _openKakaoTalk(
        clientId ?? KakaoSdk.appKey,
        redirectUri,
        channelPublicId,
        serviceTerms,
        codeVerifier,
        prompts,
        nonce,
        kauthTxId,
        stateToken: webStateToken,
        webPopupLogin: webPopupLogin,
      );

      if (kIsWeb) {
        if (webPopupLogin) {
          return response;
        }
        var params = {
          'redirect_uri': redirectUri,
          'code': response,
          'state': webStateToken
        };
        await _channel.invokeMethod('redirectForEasyLogin', params);
        return response;
      }
      return _parseCode(response);
    } catch (e) {
      SdkLog.e(e);
      rethrow;
    }
  }

  /// KO: 추가 항목 동의 받기
  /// <br>
  /// EN: Request additional consent
  Future<String> authorizeWithNewScopes({
    required List<String> scopes,
    required String redirectUri,
    String? clientId,
    String? codeVerifier,
    String? nonce,
    bool webPopupLogin = false,
  }) async {
    final agt = await _kauthApi.agt();
    try {
      return await authorize(
        clientId: clientId,
        redirectUri: redirectUri,
        scopes: scopes,
        agt: agt,
        codeVerifier: codeVerifier,
        nonce: nonce,
        webPopupLogin: webPopupLogin,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// @nodoc
  // Get platform specific redirect uri. (This method is web specific. Use after checking the platform)
  Future<String> platformRedirectUri() async {
    return await _channel.invokeMethod('platformRedirectUri');
  }

  /// @nodoc
  static String codeVerifier() {
    // remove last '='
    return base64UrlEncode(
            sha512.convert(utf8.encode(UniqueKey().toString())).bytes)
        .split('=')[0];
  }

  String _parseCode(String redirectedUri) {
    final queryParams = Uri.parse(redirectedUri).queryParameters;
    final code = queryParams[Constants.code];
    if (code != null) return code;
    throw KakaoAuthException.fromJson(queryParams);
  }

  Future<String> _openKakaoTalk(
    String clientId,
    String redirectUri,
    List<String>? channelPublicId,
    List<String>? serviceTerms,
    String? codeVerifier,
    List<Prompt>? prompts,
    String? nonce,
    String? kauthTxId, {
    String? stateToken,
    bool webPopupLogin = false,
  }) async {
    var arguments = {
      Constants.sdkVersion: "sdk/${KakaoSdk.sdkVersion} sdk_type/flutter",
      Constants.clientId: clientId,
      Constants.responseType: Constants.code,
      Constants.redirectUri: redirectUri,
      Constants.codeVerifier: codeVerifier,
      Constants.channelPublicId: channelPublicId?.join(','),
      Constants.serviceTerms: serviceTerms?.join(','),
      Constants.prompt: prompts == null ? null : _parsePrompts(prompts),
      Constants.nonce: nonce,
      Constants.stateToken: stateToken,
      Constants.isPopup: webPopupLogin,
    };
    arguments.removeWhere((k, v) => v == null);

    if (!kIsWeb) {
      if (_platform.isIOS) {
        arguments.addAll({
          'loginScheme': KakaoSdk.platforms.ios.talkLoginScheme,
          'universalLink': KakaoSdk.platforms.ios.iosLoginUniversalLink,
        });
      } else if (_platform.isAndroid) {
        arguments.addAll(
            {'talkPackageName': KakaoSdk.platforms.android.talkPackage});
      }

      final redirectUriWithParams = await _channel.invokeMethod<String>(
          CommonConstants.authorizeWithTalk, arguments);

      if (redirectUriWithParams != null) {
        return redirectUriWithParams;
      }

      throw KakaoClientException(
        ClientErrorCause.unknown,
        "OAuth 2.0 redirect uri was null, which should not happen.",
      );
    }

    await _channel.invokeMethod<String>(
        CommonConstants.authorizeWithTalk, arguments);

    String kaHeader = await KakaoSdk.kaHeader;
    return _getAuthCode(stateToken, kaHeader);
  }

  Future<String> _getAuthCode(String? stateToken, String kaHeader,
      {int count = 0, int maxCount = 600}) async {
    final completer = Completer<String>();

    await Future.doWhile(() async {
      if (count == maxCount) {
        completer.completeError(
            TimeoutException('Kakao Login timed out. Please login again.'));
        return false;
      }

      count++;
      await Future.delayed(const Duration(milliseconds: 1000));

      String response = await _kauthApi.codeForWeb(
          stateToken: stateToken!, kaHeader: kaHeader);

      if (response != 'error') {
        completer.complete(response);
        return false;
      }
      return true;
    });
    return completer.future;
  }

  String? _parsePrompts(List<Prompt> prompts) {
    if (prompts.isEmpty) return null;

    var parsedPrompt = '';
    for (var element in prompts) {
      parsedPrompt += '${element.name.toSnakeCase()} ';
    }
    return parsedPrompt;
  }

  /// @nodoc
  static String _codeChallenge(String codeVerifier) {
    // remove last '='
    return base64UrlEncode(sha256.convert(utf8.encode(codeVerifier)).bytes)
        .split('=')[0];
  }

  Future<Map<String, dynamic>> _makeAuthParams({
    String? clientId,
    String? redirectUri,
    List<String>? scopes,
    String? agt,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    List<Prompt>? prompts,
    String? loginHint,
    String? codeChallenge,
    String? nonce,
    String? kauthTxId,
    String? stateToken,
    bool? isPopup,
  }) async {
    final params = {
      Constants.clientId: clientId ?? KakaoSdk.appKey,
      Constants.redirectUri: redirectUri,
      Constants.responseType: Constants.code,
      // "approval_type": "individual",
      Constants.scope: scopes?.join(" "),
      Constants.agt: agt,
      Constants.channelPublicId: channelPublicIds?.join(','),
      Constants.serviceTerms: serviceTerms?.join(','),
      Constants.prompt: prompts == null ? null : _parsePrompts(prompts),
      Constants.loginHint: loginHint,
      Constants.codeChallenge: codeChallenge,
      Constants.codeChallengeMethod:
          codeChallenge != null ? Constants.codeChallengeMethodValue : null,
      Constants.kaHeader: await KakaoSdk.kaHeader,
      Constants.nonce: nonce,
      Constants.state: stateToken,
      Constants.stateToken: stateToken,
      Constants.isPopup: isPopup,
    };
    params.removeWhere((k, v) => v == null);
    return params;
  }
}
