import '../common_platform.dart';
import '../model/kakao_client_exception.dart';
import '../model/platform_data.dart';

/// @nodoc
class CommonPlatformImpl extends CommonPlatform {
  @override
  Future<PlatformData> getPlatformData() async {
    throw _notSupportedError();
  }

  @override
  Future<bool> isAppInstalled({String? packageName, String? appScheme}) async {
    throw _notSupportedError();
  }

  @override
  Future<bool> isKakaoTalkAvailable(String? appScheme) async {
    throw _notSupportedError();
  }

  @override
  Future<void> launchUrl(String url, {bool useBrowserSession = false}) async {
    throw _notSupportedError();
  }

  @override
  void setDeepLinkCallback(Function(String url)? callback) {
    throw _notSupportedError();
  }

  KakaoClientException _notSupportedError() {
    return KakaoClientException.notSupported();
  }
}
