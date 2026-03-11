import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/src/platform/talk_platform_stub.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  test('talk stub throws consistent notSupported error', () async {
    final platform = TalkPlatformImpl();

    await expectLater(
      platform.addChannel('channel-public-id'),
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
