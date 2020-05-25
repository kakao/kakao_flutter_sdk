import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/src/auth/auth_api.dart';
import 'package:platform/platform.dart';

const MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

/// Provides OAuth authorization process.
///
/// Corresponds to Authorization Endpoint of [OAuth 2.0 spec](https://tools.ietf.org/html/rfc6749).
class AuthCodeClient {
  AuthCodeClient({AuthApi authApi, Platform platform})
      : _kauthApi = authApi ?? AuthApi.instance,
        _platform = platform ?? LocalPlatform();

  final AuthApi _kauthApi;
  final Platform _platform;

  static final AuthCodeClient instance = AuthCodeClient();

  /// Requests authorization code via `Chrome Custom Tabs` (on Android) and `ASWebAuthenticationSession` (on iOS).
  Future<String> request(
      {String clientId, String redirectUri, List<String> scopes}) async {
    final finalRedirectUri = redirectUri ?? "kakao${_platformKey()}://oauth";

    final params = {
      "client_id": clientId ?? _platformKey(),
      "redirect_uri": finalRedirectUri,
      "response_type": "code",
      "approval_type": "individual",
      "scope": scopes == null ? null : scopes.join(" "),
      "ka": await KakaoContext.kaHeader
    };
    params.removeWhere((k, v) => v == null);
    final url = Uri.https(KakaoContext.hosts.kauth, "/oauth/authorize", params);
    final authCode = await launchBrowserTab(url, redirectUri: finalRedirectUri);
    return _parseCode(authCode);
  }

  /// Requests authorization code via KakaoTalk.
  ///
  /// This will only work on devices where KakaoTalk is installed.
  /// You MUST check if KakaoTalk is installed before calling this method with [isKakaoTalkInstalled].
  Future<String> requestWithTalk(
      {String clientId, String redirectUri, List<String> scopes}) async {
    return _parseCode(await _openKakaoTalk(clientId ?? _platformKey(),
        redirectUri ?? "kakao${_platformKey()}://oauth"));
  }

  Future<String> requestWithAgt(List<String> scopes,
      {String clientId, String redirectUri}) async {
    final agt = await _kauthApi.agt();
    final finalRedirectUri = redirectUri ?? "kakao${_platformKey()}://oauth";
    final params = {
      "client_id": clientId ?? _platformKey(),
      "redirect_uri": finalRedirectUri,
      "response_type": "code",
      "agt": agt,
      "scope": scopes == null ? null : scopes.join(" "),
      "ka": await KakaoContext.kaHeader
    };
    params.removeWhere((k, v) => v == null);
    final url = Uri.https(KakaoContext.hosts.kauth, "/oauth/authorize", params);
    return _parseCode(
        await launchBrowserTab(url, redirectUri: finalRedirectUri));
  }

  void retrieveAuthCode() {
    _channel.invokeMethod("retrieveAuthCode");
  }

  String _parseCode(String redirectedUri) {
    final queryParams = Uri.parse(redirectedUri).queryParameters;
    final code = queryParams["code"];
    if (code != null) return code;
    throw KakaoAuthException.fromJson(queryParams);
  }

  Future<String> _openKakaoTalk(String clientId, String redirectUri) async {
    return _channel.invokeMethod("authorizeWithTalk",
        {"client_id": clientId, "redirect_uri": redirectUri});
  }

  String _platformKey() {
    if (kIsWeb) {
      return KakaoContext.javascriptClientId;
    }
    if (_platform.isAndroid || _platform.isIOS) {
      return KakaoContext.clientId;
    }
    return KakaoContext.javascriptClientId;
  }

  // String _platformRedirectUri() {
  //   if (kIsWeb) {
  //     return "${html.win}"
  //   }
  // }
}
