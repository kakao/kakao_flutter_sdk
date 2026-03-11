import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_share/src/platform/share_platform_stub.dart';

void main() {
  test('share stub throws consistent notSupported error', () async {
    final platform = SharePlatformImpl();

    await expectLater(
      platform.isKakaoTalkSharingAvailable(),
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
