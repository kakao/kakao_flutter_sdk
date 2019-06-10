import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:kakao_flutter_sdk/src/kakao_context.dart';

class AuthCodeClient {
  Future<void> launchAutorizeUrl(
      [String clientId, String redirectUri, List<String> scopes]) async {
    var url = Uri.https("kauth.kakao.com", "/oauth/authorize", {
      "client_id": clientId ?? KakaoContext.clientId,
      "redirect_uri": redirectUri ?? "kakao${KakaoContext.clientId}://oauth",
      "response_type": "code",
      "approval_type": "individual"
    });

    await launch(url.toString(),
        option:
            CustomTabsOption(enableUrlBarHiding: false, showPageTitle: false));
  }
}
