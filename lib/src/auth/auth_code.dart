import 'package:kakao_flutter_sdk/src/auth/default_browser.dart';
import 'package:kakao_flutter_sdk/src/kakao_context.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_auth_exception.dart';

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
    var redirectedUriString = await launchWithBrowserTab(url, finalRedirectUri);
    var queryParams = Uri.parse(redirectedUriString).queryParameters;
    var code = queryParams["code"];
    if (code != null) return code;
    throw KakaoAuthException.fromJson(queryParams);
  }
}
