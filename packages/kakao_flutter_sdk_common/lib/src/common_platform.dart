import 'model/platform_data.dart';
import 'platform/common_platform_stub.dart'
    if (dart.library.io) 'platform/common_platform_native.dart'
    if (dart.library.html) 'web/common_platform_web.dart';

/// @nodoc
abstract class CommonPlatform {
  static final CommonPlatform instance = CommonPlatformImpl();

  Future<PlatformData> getPlatformData();

  Future<bool> isAppInstalled({String? packageName, String? appScheme});

  // 안드로이드에서 톡 유효성 체크를 위해 메소드 분리. 나머지는 isAppInstalled로 처리.
  Future<bool> isKakaoTalkAvailable(String? appScheme);

  // 실행 결과를 반환하지 않고 단순히 url 실행할 때 사용
  // useBrowserSession은 ios에서만 사용
  Future<void> launchUrl(String url, {bool useBrowserSession = false});

  void setDeepLinkCallback(Function(String url)? callback);
}
