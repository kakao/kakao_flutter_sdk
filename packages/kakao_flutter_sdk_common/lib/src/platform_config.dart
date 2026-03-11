/// @nodoc
class PlatformSupport {
  const PlatformSupport({
    // All Platforms
    required this.talkSharingScheme,
    required this.talkChannelScheme,
    required this.kakaoNaviScheme,
    required this.kakaoNaviInstallPage,
    // Android Specific
    required this.talkPackageName,
    required this.kakaoNaviPackage,
    // iOS Specific
    required this.talkLoginScheme,
    required this.iosLoginUniversalLink,
    required this.iosInAppLoginScheme,
  });

  // All Platforms
  final String talkSharingScheme;
  final String talkChannelScheme;
  final String kakaoNaviScheme;
  final String kakaoNaviInstallPage;

  // Android Specific
  final String talkPackageName;
  final String kakaoNaviPackage;

  // iOS Specific
  final String talkLoginScheme;
  final String iosLoginUniversalLink;
  final String iosInAppLoginScheme;
}

/// @nodoc
class DefaultPlatformSupport extends PlatformSupport {
  DefaultPlatformSupport()
    : super(
        talkSharingScheme: 'kakaolink',
        talkChannelScheme: 'kakaoplus://plusfriend',
        kakaoNaviScheme: 'kakaonavi-sdk://navigate',
        kakaoNaviInstallPage: 'https://kakaonavi.kakao.com/launch/index.do',
        talkPackageName: 'com.kakao.talk',
        kakaoNaviPackage: 'com.locnall.KimGiSa',
        talkLoginScheme: 'kakaokompassauth://authorize',
        iosLoginUniversalLink: 'https://talk-apps.kakao.com/scheme/',
        iosInAppLoginScheme: 'kakaotalk://inappbrowser',
      );
}
