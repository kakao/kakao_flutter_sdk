import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/utils.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

const MethodChannel _channel = MethodChannel(CommonConstants.methodChannel);

/// Kakao SDK의 카카오 로그인 내부 동작에 사용되는 클라이언트
class AuthCodeClient {
  AuthCodeClient({AuthApi? authApi}) : _kauthApi = authApi ?? AuthApi.instance;

  final AuthApi _kauthApi;

  static final AuthCodeClient instance = AuthCodeClient();

  /// 사용자가 앱에 로그인할 수 있도록 인가 코드를 요청하는 함수입니다. 인가 코드를 받을 수 있는 서버 개발이 필요합니다.
  Future<String> authorize({
    String? clientId,
    String? redirectUri,
    List<String>? scopes,
    String? agt,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    List<Prompt>? prompts,
    String? loginHint,
    String? state,
    String? codeVerifier,
    String? nonce,
    bool webPopupLogin = false,
  }) async {
    final finalRedirectUri = redirectUri ?? "kakao${_platformKey()}://oauth";
    String? codeChallenge = codeVerifier != null
        ? base64.encode(sha256.convert(utf8.encode(codeVerifier)).bytes)
        : null;
    final params = {
      Constants.clientId: clientId ?? _platformKey(),
      Constants.redirectUri: finalRedirectUri,
      Constants.responseType: Constants.code,
      // "approval_type": "individual",
      Constants.scope: scopes?.join(" "),
      Constants.agt: agt,
      Constants.channelPublicId: channelPublicIds?.join(','),
      Constants.serviceTerms: serviceTerms?.join(','),
      Constants.prompt: state == null
          ? (prompts == null ? null : _parsePrompts(prompts))
          : _parsePrompts(_makeCertPrompts(prompts)),
      Constants.loginHint: loginHint,
      Constants.state: state,
      Constants.codeChallenge: codeChallenge,
      Constants.codeChallengeMethod:
          codeChallenge != null ? Constants.codeChallengeMethodValue : null,
      Constants.kaHeader: await KakaoSdk.kaHeader,
      Constants.nonce: nonce,
    };
    params.removeWhere((k, v) => v == null);
    final url =
        Uri.https(KakaoSdk.hosts.kauth, Constants.authorizePath, params);
    SdkLog.i(url);

    try {
      final authCode = await launchBrowserTab(
        url,
        redirectUri: finalRedirectUri,
        popupOpen: webPopupLogin,
      );

      return _parseCode(authCode);
    } catch (e) {
      SdkLog.e(e);
      rethrow;
    }
  }

  /// 사용자가 앱에 로그인할 수 있도록 사용자의 디바이스에 설치된 카카오톡을 통해 인가 코드를 요청하는 함수입니다.
  /// 인가 코드를 받을 수 있는 서버 개발이 필요합니다.
  Future<String> authorizeWithTalk({
    String? clientId,
    String? redirectUri,
    List<Prompt>? prompts,
    List<String>? channelPublicId,
    List<String>? serviceTerms,
    String? state,
    String? codeVerifier,
    String? nonce,
    String? stateToken,
    bool webPopupLogin = false,
  }) async {
    try {
      final webStateToken =
          stateToken ?? (kIsWeb ? generateRandomString(20) : null);

      var response = await _openKakaoTalk(
        clientId ?? _platformKey(),
        redirectUri ?? "kakao${_platformKey()}://oauth",
        channelPublicId,
        serviceTerms,
        codeVerifier,
        prompts,
        state,
        nonce,
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

  /// 사용자가 아직 동의하지 않은 개인정보 및 접근권한 동의 항목에 대하여 동의를 요청 화면을 출력하고 인가 코드를 요청하는 함수입니다.
  /// 인가 코드를 받을 수 있는 서버 개발이 필요합니다.
  Future<String> authorizeWithNewScopes({
    required List<String> scopes,
    String? clientId,
    String? redirectUri,
    String? codeVerifier,
    String? nonce,
    bool webPopupLogin = false,
  }) async {
    final agt = await _kauthApi.agt();
    try {
      return authorize(
          clientId: clientId,
          redirectUri: redirectUri,
          scopes: scopes,
          agt: agt,
          codeVerifier: codeVerifier,
          nonce: nonce,
          webPopupLogin: webPopupLogin);
    } catch (e) {
      rethrow;
    }
  }

  // Retrieve auth code in web environment. (This method is web specific. Use after checking the platform)
  void _retrieveAuthCode() {
    _channel.invokeMethod("retrieveAuthCode");
  }

  /// @nodoc
  // Get platform specific redirect uri. (This method is web specific. Use after checking the platform)
  Future<String> platformRedirectUri() async {
    return await _channel.invokeMethod('platformRedirectUri');
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
    String? state,
    String? nonce, {
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
      Constants.prompt: state == null
          ? (prompts == null ? null : _parsePrompts(prompts))
          : _parsePrompts(_makeCertPrompts(prompts)),
      Constants.state: state,
      Constants.nonce: nonce,
      Constants.stateToken: stateToken,
      Constants.isPopup: webPopupLogin,
    };
    arguments.removeWhere((k, v) => v == null);

    if (!kIsWeb) {
      final redirectUriWithParams = await _channel.invokeMethod<String>(
          CommonConstants.authorizeWithTalk, arguments);

      if (redirectUriWithParams != null) {
        return redirectUriWithParams;
      }

      throw KakaoClientException(
          "OAuth 2.0 redirect uri was null, which should not happen.");
    }

    await _channel.invokeMethod<String>(
        CommonConstants.authorizeWithTalk, arguments);

    String kaHeader = await _channel.invokeMethod('getKaHeader');

    int count = 0;
    const maxCount = 600;
    Completer<String> completer = Completer();

    await Future.doWhile(() async {
      if (count == maxCount) {
        completer.completeError(
            TimeoutException('KakaoTalk login timed out. Please login again.'));
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

  List<Prompt> _makeCertPrompts(List<Prompt>? prompts) {
    prompts ??= [];
    if (!prompts.contains(Prompt.cert)) {
      prompts.add(Prompt.cert);
    }
    return prompts;
  }

  String _parsePrompts(List<Prompt> prompts) {
    var parsedPrompt = '';
    for (var element in prompts) {
      parsedPrompt += '${describeEnum(element).toLowerCase()} ';
    }
    return parsedPrompt;
  }

  String _platformKey() {
    return KakaoSdk.appKey;
  }

  /// @nodoc
  static String codeVerifier() {
    return base64
        .encode(sha512.convert(utf8.encode(UniqueKey().toString())).bytes);
  }
}

/// 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때 전달하는 파라미터
enum Prompt {
  /// 기본 웹 브라우저(CustomTabs)에 카카오계정 cookie 가 이미 있더라도 이를 무시하고 무조건 로그인 화면을 보여주도록 함
  login,

  /// @nodoc
  cert
}
