import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:web/web.dart';

import '../share_platform.dart';

/// @nodoc
class SharePlatformImpl extends SharePlatform {
  @override
  Future<bool> isKakaoTalkSharingAvailable() =>
      CommonPlatform.instance.isKakaoTalkAvailable(null);

  @override
  Future<void> launchKakaoTalk(String url) async {
    if (!isMobileWeb()) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'KakaoTalk sharing is only supported on mobile web.',
      );
    }

    if (isAndroidWeb()) {
      final intent = _getAndroidShareIntent(url);
      window.location.href = intent;
      return;
    }

    window.location.href = url;
  }

  @override
  Map<String, String> platformExtras() {
    return {};
  }

  String _getAndroidShareIntent(String url) {
    final scheme = KakaoSdk.platform.talkSharingScheme;

    final queryParams = Uri.parse(url).query;
    final intentScheme = 'intent://send?$queryParams#Intent;scheme=$scheme';

    final intent = [
      intentScheme,
      'launchFlags=0x14008000',
      'package=${KakaoSdk.platform.talkPackageName}',
      'end;',
    ].join(';');
    return intent;
  }
}
