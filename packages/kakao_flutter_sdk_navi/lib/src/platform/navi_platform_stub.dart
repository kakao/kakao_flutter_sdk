import '../navi_platform.dart';
import '../model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// @nodoc
class NaviPlatformImpl extends NaviPlatform {
  @override
  Future<bool> isKakaoNaviInstalled() async {
    throw _notSupportedError();
  }

  @override
  Future<void> navigate(KakaoNaviParams params) async {
    throw _notSupportedError();
  }

  KakaoClientException _notSupportedError() {
    return KakaoClientException.notSupported();
  }
}
