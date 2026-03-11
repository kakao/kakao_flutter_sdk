import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'shared/doubles/fake_common_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('KakaoSdk init test', () async {
    const nativeAppKey = 'test_app_key';

    // Given & When
    await KakaoSdk.init(
      nativeAppKey: nativeAppKey,
      platformProvider: FakeCommonPlatform(),
    );

    // Then
    expect(KakaoSdk.appKey, isNotNull);
    expect(KakaoSdk.appKey, equals(nativeAppKey));
    expect(KakaoSdk.redirectUri, isNotNull);
    expect(KakaoSdk.hosts, isNotNull);
    expect(KakaoSdk.platformInfo, isNotNull);
    expect(KakaoSdk.platform, isNotNull);
  });

  test('KakaoSdk init throws badParameter when app key is missing', () async {
    await expectLater(
      KakaoSdk.init(platformProvider: FakeCommonPlatform()),
      throwsA(
        isA<KakaoClientException>().having(
          (e) => e.reason,
          'reason',
          ClientErrorCause.badParameter,
        ),
      ),
    );
  });
}
