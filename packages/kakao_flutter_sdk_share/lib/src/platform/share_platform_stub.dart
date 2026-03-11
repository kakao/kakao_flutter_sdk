import '../share_platform.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// @nodoc
class SharePlatformImpl extends SharePlatform {
  @override
  Future<bool> isKakaoTalkSharingAvailable() async {
    throw _notSupportedError();
  }

  @override
  Future<void> launchKakaoTalk(String url) async {
    throw _notSupportedError();
  }

  @override
  Map<String, String> platformExtras() {
    throw _notSupportedError();
  }

  KakaoClientException _notSupportedError() {
    return KakaoClientException.notSupported();
  }
}
