import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../kakao_flutter_sdk_share.dart';
import 'platform/share_platform_stub.dart'
    if (dart.library.io) 'platform/share_platform_native.dart'
    if (dart.library.html) 'web/share_platform_web.dart';

/// @nodoc
abstract class SharePlatform {
  static final SharePlatform instance = SharePlatformImpl();

  Future<bool> isKakaoTalkSharingAvailable();

  Future<void> launchKakaoTalk(String url);

  Future<void> launchBrowser(String url) async {
    try {
      await CommonPlatform.instance.launchUrl(url, useBrowserSession: true);
    } catch (_) {
      // 유저가 공유가 성공해서 브라우저를 닫은건지, 취소하려고 닫은건지 구분할 수 없어서 에러를 전달하지 않음.
    }
  }

  Map<String, String> platformExtras();
}
