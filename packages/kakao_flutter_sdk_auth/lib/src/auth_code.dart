import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk_auth/src/auth_api.dart';
import 'package:kakao_flutter_sdk_common/common.dart';

const MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

/// @nodoc
// Provides OAuth authorization process.
// Corresponds to Authorization Endpoint of [OAuth 2.0 spec](https://tools.ietf.org/html/rfc6749).
class AuthCodeClient {
  AuthCodeClient({AuthApi? authApi, Platform? platform})
      : _kauthApi = authApi ?? AuthApi.instance,
        _platform = platform ?? LocalPlatform();

  final AuthApi _kauthApi;
  final Platform _platform;

  static final AuthCodeClient instance = AuthCodeClient();

  // Requests authorization code via `Chrome Custom Tabs` (on Android) and `ASWebAuthenticationSession` (on iOS).
  Future<String> request(
      {String? clientId,
      String? redirectUri,
      String? codeVerifier,
      List<Prompt>? prompts,
      List<String>? scopes,
      String? state}) async {
    final finalRedirectUri = redirectUri ?? "kakao${_platformKey()}://oauth";
    var codeChallenge;
    if (codeVerifier != null) {
      codeChallenge =
          base64.encode(sha256.convert(utf8.encode(codeVerifier)).bytes);
    }
    final params = {
      "client_id": clientId ?? _platformKey(),
      "redirect_uri": finalRedirectUri,
      "response_type": "code",
      // "approval_type": "individual",
      "scope": scopes == null ? null : scopes.join(" "),
      "prompt": state == null
          ? (prompts == null ? null : parsePrompts(prompts))
          : parsePrompts(_makeCertPrompts(prompts)),
      "state": state == null ? null : state,
      "codeChallenge": codeChallenge,
      "codeChallengeMethod": codeChallenge != null ? "S256" : null,
      "ka": await KakaoSdk.kaHeader
    };
    params.removeWhere((k, v) => v == null);
    final url = Uri.https(KakaoSdk.hosts.kauth, "/oauth/authorize", params);
    final authCode = await launchBrowserTab(url, redirectUri: finalRedirectUri);
    return _parseCode(authCode);
  }

  // Requests authorization code via KakaoTalk.
  //
  // This will only work on devices where KakaoTalk is installed.
  // You MUST check if KakaoTalk is installed before calling this method with [isKakaoTalkInstalled].
  Future<String> requestWithTalk(
      {String? clientId,
      String? redirectUri,
      List<String>? scopes,
      List<Prompt>? prompts,
      String? state,
      String? codeVerifier}) async {
    return _parseCode(await _openKakaoTalk(
        clientId ?? _platformKey(),
        redirectUri ?? "kakao${_platformKey()}://oauth",
        codeVerifier,
        prompts,
        state));
  }

  // Requests authorization code with current access token.
  //
  // User should be logged in in order to call this method.
  Future<String> requestWithAgt(List<String> scopes,
      {String? clientId, String? redirectUri}) async {
    final agt = await _kauthApi.agt();
    final finalRedirectUri = redirectUri ?? "kakao${_platformKey()}://oauth";
    final params = {
      "client_id": clientId ?? _platformKey(),
      "redirect_uri": finalRedirectUri,
      "response_type": "code",
      "agt": agt,
      "scope": scopes.length == 0 ? null : scopes.join(" "),
      "ka": await KakaoSdk.kaHeader
    };
    params.removeWhere((k, v) => v == null);
    final url = Uri.https(KakaoSdk.hosts.kauth, "/oauth/authorize", params);
    return _parseCode(
        await launchBrowserTab(url, redirectUri: finalRedirectUri));
  }

  // Retreives auth code in web environment. (This method is web specific. Use after checking the platform)
  void retrieveAuthCode() {
    _channel.invokeMethod("retrieveAuthCode");
  }

  String _parseCode(String redirectedUri) {
    final queryParams = Uri.parse(redirectedUri).queryParameters;
    final code = queryParams["code"];
    if (code != null) return code;
    throw KakaoAuthException.fromJson(queryParams);
  }

  Future<String> _openKakaoTalk(String clientId, String redirectUri,
      String? codeVerifier, List<Prompt>? prompts, String? state) async {
    var arguments = {
      "sdk_version": "sdk/${KakaoSdk.sdkVersion} sdk_type/flutter",
      "client_id": clientId,
      "redirect_uri": redirectUri,
      "code_verifier": codeVerifier,
      "prompt": state == null
          ? (prompts == null ? null : parsePrompts(prompts))
          : parsePrompts(_makeCertPrompts(prompts)),
      "state": state == null ? null : state,
    };
    arguments.removeWhere((k, v) => v == null);
    final redirectUriWithParams =
        await _channel.invokeMethod<String>("authorizeWithTalk", arguments);
    if (redirectUriWithParams != null) return redirectUriWithParams;
    throw KakaoClientException(
        "OAuth 2.0 redirect uri was null, which should not happen.");
  }

  List<Prompt> _makeCertPrompts(List<Prompt>? prompts) {
    if (prompts == null) {
      prompts = [];
    }
    if (!prompts.contains(Prompt.CERT)) {
      prompts.add(Prompt.CERT);
    }
    return prompts;
  }

  String parsePrompts(List<Prompt> prompts) {
    var parsedPrompt = '';
    prompts.forEach((element) {
      parsedPrompt += '${describeEnum(element).toLowerCase()} ';
    });
    return parsedPrompt;
  }

  String _platformKey() {
    if (kIsWeb) {
      return KakaoSdk.jsKey;
    }
    if (_platform.isAndroid || _platform.isIOS) {
      return KakaoSdk.nativeKey;
    }
    return KakaoSdk.jsKey;
  }

  static String codeVerifier() {
    return base64
        .encode(sha512.convert(utf8.encode(UniqueKey().toString())).bytes);
  }

// String _platformRedirectUri() {
//   if (kIsWeb) {
//     return "${html.win}"
//   }
// }
}

/// 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때 전달하는 파라미터
enum Prompt {
  /// 기본 웹 브라우저(CustomTabs)에 카카오계정 cookie 가 이미 있더라도 이를 무시하고 무조건 로그인 화면을 보여주도록 함
  LOGIN,

  /// @nodoc
  CERT
}
