/// @nodoc
class CommonConstants {
  static const String scheme = 'https';
  static const String bearer = 'Bearer';
  static const String authorization = 'Authorization';
  static const String contentType = 'application/x-www-form-urlencoded';

  static const String kakaoAk = 'KakaoAK';

  static const String ka = 'KA';

  static const String http = 'http';
  static const String url = 'url';
  static const String redirectUri = 'redirect_uri';
  static const String androidWebRedirectUri = '/cors/afterlogin.html';
  static const String iosWebRedirectUri = 'JS-SDK';
  static const String iosWebUniversalLink =
      'https://talk-apps.kakao.com/scheme/';
  static const String iosTalkLoginScheme = 'kakaokompassauth://authorize';
  static const String iosInAppLoginScheme = 'kakaotalk://inappbrowser';

  static const String methodChannel = 'kakao_flutter_sdk';
  static const String appVer = 'appVer';
  static const String packageName = 'packageName';
  static const String getOrigin = 'getOrigin';
  static const String getKaHeader = 'getKaHeader';
  static const String launchBrowserTab = 'launchBrowserTab';
  static const String authorizeWithTalk = 'authorizeWithTalk';
  static const String isKakaoTalkInstalled = 'isKakaoTalkInstalled';
  static const String isKakaoNaviInstalled = 'isKakaoNaviInstalled';
  static const String launchKakaoTalk = 'launchKakaoTalk';
  static const String isKakaoTalkSharingAvailable =
      'isKakaoTalkSharingAvailable';
  static const String navigate = 'navigate';
  static const String shareDestination = 'shareDestination';
  static const String isPopup = 'is_popup';
}
