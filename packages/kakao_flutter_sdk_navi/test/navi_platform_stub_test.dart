import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_navi/src/platform/navi_platform_stub.dart';

void main() {
  test('navi stub throws consistent notSupported error', () async {
    final platform = NaviPlatformImpl();

    await expectLater(
      platform.isKakaoNaviInstalled(),
      throwsA(
        isA<KakaoClientException>()
            .having((e) => e.reason, 'reason', ClientErrorCause.notSupported)
            .having(
              (e) => e.msg,
              'msg',
              'This SDK operation is not supported on this platform.',
            ),
      ),
    );
  });
}
