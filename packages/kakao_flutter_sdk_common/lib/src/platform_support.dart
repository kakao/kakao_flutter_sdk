/// @nodoc
class PlatformSupport {
  late final PlatformSupportValues android;
  late final PlatformSupportValues ios;
  late final PlatformSupportValues web;

  PlatformSupport({
    PlatformSupportValues? android,
    PlatformSupportValues? ios,
    PlatformSupportValues? web,
  }) {
    this.android = android ?? DefaultAndroid();
    this.ios = ios ?? DefaultiOS();
    this.web = web ?? DefaultWeb();
  }
}

/// @nodoc
class PlatformSupportValues {
  late final String talkPackage;
  late final String talkLoginScheme;
  late final String talkSharingScheme;
  late final String talkChannelScheme;
  late final String kakaoNaviScheme;
  late final String kakaoNaviInstallPage;
  late final String kakaoNaviOrigin;
  late final String iosLoginUniversalLink;
  late final String iosInAppLoginScheme;
}

/// @nodoc
class DefaultAndroid extends PlatformSupportValues {
  @override
  String get talkPackage => 'com.kakao.talk';

  @override
  String get talkSharingScheme => 'kakaolink';

  @override
  String get talkChannelScheme => 'kakaoplus://plusfriend';

  @override
  String get kakaoNaviScheme => 'kakaonavi-sdk://navigate';

  @override
  String get kakaoNaviInstallPage =>
      'https://kakaonavi.kakao.com/launch/index.do';

  @override
  String get kakaoNaviOrigin => 'com.locnall.KimGiSa';
}

/// @nodoc
class DefaultiOS extends PlatformSupportValues {
  @override
  String get talkLoginScheme => 'kakaokompassauth://authorize';

  @override
  String get iosLoginUniversalLink => 'https://talk-apps.kakao.com/scheme/';

  @override
  String get talkSharingScheme => 'kakaolink';

  @override
  String get talkChannelScheme => 'kakaoplus://plusfriend';

  @override
  String get kakaoNaviScheme => 'kakaonavi-sdk://navigate';

  @override
  String get kakaoNaviInstallPage =>
      'https://kakaonavi.kakao.com/launch/index.do';
}

/// @nodoc
class DefaultWeb extends PlatformSupportValues {
  // for android
  @override
  String get talkPackage => 'com.kakao.talk';

  @override
  String get talkSharingScheme => 'kakaolink';

  @override
  String get talkChannelScheme => 'kakaoplus://plusfriend';

  @override
  String get kakaoNaviScheme => 'kakaonavi-sdk://navigate';

  // for android
  @override
  String get kakaoNaviOrigin => 'com.locnall.KimGiSa';

  @override
  String get kakaoNaviInstallPage =>
      'https://kakaonavi.kakao.com/launch/index.do';

  // for ios
  @override
  String get iosLoginUniversalLink => 'https://talk-apps.kakao.com/scheme/';

  // for ios
  @override
  String get talkLoginScheme => 'kakaokompassauth://authorize';

  // for ios
  @override
  String get iosInAppLoginScheme => 'kakaotalk://inappbrowser';
}
