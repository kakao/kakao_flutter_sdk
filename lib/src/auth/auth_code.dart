import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/src/common/default_browser.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_auth_exception.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_context.dart';

const MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

/// Provides OAuth authorization process.
///
/// Corresponds to Authorization Endpoint of [OAuth 2.0 spec](https://tools.ietf.org/html/rfc6749).
class AuthCodeClient {
  static final AuthCodeClient instance = AuthCodeClient();

  Future<String> request(
      {String clientId, String redirectUri, List<String> scopes}) async {
    var finalRedirectUri =
        redirectUri ?? "kakao${KakaoContext.clientId}://oauth";

    final params = {
      "client_id": clientId ?? KakaoContext.clientId,
      "redirect_uri": finalRedirectUri,
      "response_type": "code",
      "approval_type": "individual",
      "scope": scopes == null ? null : scopes.join(" ")
    };
    params.removeWhere((k, v) => v == null);
    var url = Uri.https("kauth.kakao.com", "/oauth/authorize", params);
    return _parseCode(await launchWithBrowserTab(url, finalRedirectUri));
  }

  Future<String> requestWithTalk(
      {String clientId, String redirectUri, List<String> scopes}) async {
    return _parseCode(await _openKakaoTalk(clientId ?? KakaoContext.clientId,
        redirectUri ?? "kakao${KakaoContext.clientId}://oauth"));
  }

  String _parseCode(String redirectedUri) {
    var queryParams = Uri.parse(redirectedUri).queryParameters;
    var code = queryParams["code"];
    if (code != null) return code;
    throw KakaoAuthException.fromJson(queryParams);
  }

  Future<String> _openKakaoTalk(String clientId, String redirectUri) async {
    return _channel.invokeMethod("authorizeWithTalk",
        {"client_id": clientId, "redirect_uri": redirectUri});
  }
}
