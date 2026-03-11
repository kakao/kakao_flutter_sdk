import 'dart:typed_data';

import 'package:kakao_flutter_sdk_common/src/common_platform.dart';
import 'package:kakao_flutter_sdk_common/src/model/platform_data.dart';

class FakeCommonPlatform extends CommonPlatform {
  @override
  Future<PlatformData> getPlatformData() async {
    return PlatformData(
      origin: 'test.origin.com',
      kaHeader: 'os/test app_ver/1.0.0',
      appVer: '1.0.0',
      platformId: Uint8List.fromList([1, 2, 3, 4]),
      packageName: 'com.test.app',
    );
  }

  @override
  Future<bool> isAppInstalled({String? packageName, String? appScheme}) async {
    return true;
  }

  @override
  Future<bool> isKakaoTalkAvailable(String? appScheme) async {
    return true;
  }

  @override
  Future<void> launchUrl(String url, {bool useBrowserSession = false}) async {
    throw UnimplementedError();
  }

  @override
  void setDeepLinkCallback(Function(String url)? callback) {
    throw UnimplementedError();
  }
}
