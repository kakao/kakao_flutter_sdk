import '../kakao_flutter_sdk_common.dart';

/// KO: 카카오톡 앱 실행 가능 여부 조회
/// <br>
/// EN: Returns whether Kakao Talk is available to launch
Future<bool> isKakaoTalkInstalled() async {
  return await CommonPlatform.instance.isKakaoTalkAvailable(null);
}

/// KO: 기본 브라우저로 URL 실행
/// <br>
/// EN: Launch a URL with the default browser<br>
Future<void> launchBrowser(Uri uri, {bool useBrowserSessionOnIOS = false}) {
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    throw KakaoClientException(
      ClientErrorCause.notSupported,
      'Default browsers only supports URL of http or https scheme.',
    );
  }

  return CommonPlatform.instance.launchUrl(
    uri.toString(),
    useBrowserSession: useBrowserSessionOnIOS,
  );
}

/// KO: 앱을 커스텀 URL 스킴 호출로 실행할 때 URL 전달
/// <br>
/// EN: Pass the URL when launching a app with a custom URL scheme
void receiveKakaoScheme(Function(Uri)? callback) {
  CommonPlatform.instance.setDeepLinkCallback(
    (url) => callback?.call(Uri.parse(url)),
  );
}
