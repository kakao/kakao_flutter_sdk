import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/src/platform/user_platform_stub.dart';

void main() {
  test('user stub throws consistent notSupported error', () async {
    final platform = UserPlatformImpl();

    await expectLater(
      platform.selectShippingAddress(),
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
