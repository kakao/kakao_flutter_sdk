import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/platform/auth_platform_stub.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  test('auth stub throws consistent notSupported error', () async {
    final platform = AuthPlatformImpl();

    await expectLater(
      platform.authorizeWithTalk('kakao://oauth', null, null, null, null),
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
