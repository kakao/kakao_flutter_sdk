import 'model/kakao_navi_params.dart';
import 'platform/navi_platform_stub.dart'
    if (dart.library.io) 'platform/navi_platform_native.dart'
    if (dart.library.html) 'web/navi_platform_web.dart';

/// @nodoc
abstract class NaviPlatform {
  static final NaviPlatform instance = NaviPlatformImpl();

  Future<bool> isKakaoNaviInstalled();

  Future<void> navigate(KakaoNaviParams params);
}
