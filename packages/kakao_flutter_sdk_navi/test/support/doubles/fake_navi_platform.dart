import 'package:kakao_flutter_sdk_navi/src/model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk_navi/src/navi_platform.dart';

class FakeNaviPlatform extends NaviPlatform {
  bool isInstalled = false;
  final List<KakaoNaviParams> navigateCalls = [];

  @override
  Future<bool> isKakaoNaviInstalled() async {
    return isInstalled;
  }

  @override
  Future<void> navigate(KakaoNaviParams params) async {
    navigateCalls.add(params);
  }
}
