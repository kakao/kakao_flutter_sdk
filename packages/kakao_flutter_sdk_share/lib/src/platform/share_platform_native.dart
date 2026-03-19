import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../constants.dart';
import '../share_platform.dart';

/// @nodoc
class SharePlatformImpl extends SharePlatform {
  @override
  Future<bool> isKakaoTalkSharingAvailable() async {
    final appScheme = KakaoSdk.platformInfo.isAndroid
        ? KakaoSdk.platform.android.talkSharingScheme
        : KakaoSdk.platform.ios.talkSharingScheme;
    return CommonPlatform.instance.isKakaoTalkAvailable('$appScheme://send');
  }

  @override
  Future<void> launchKakaoTalk(String url) async {
    await CommonPlatform.instance.launchUrl(url, useBrowserSession: true);
  }

  @override
  Map<String, String> platformExtras() {
    if (KakaoSdk.platformInfo.isAndroid) {
      return {
        Constants.appPkg: KakaoSdk.platformInfo.packageName!,
        Constants.keyHash: KakaoSdk.platformInfo.origin,
      };
    } else {
      return {Constants.iosBundleId: KakaoSdk.platformInfo.origin};
    }
  }
}
