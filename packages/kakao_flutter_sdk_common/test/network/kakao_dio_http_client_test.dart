import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../shared/doubles/fake_common_platform.dart';
import '../shared/doubles/fake_http_client_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: 'test_app_key',
      platformProvider: FakeCommonPlatform(),
    );
  });

  test('404 response maps to notSupported client exception', () async {
    final adapter = FakeHttpClientAdapter()
      ..mockFirstRequestFails = true
      ..errorStatusCode = 404
      ..errorData = {'code': -9, 'msg': 'deprecated'};
    final dio = Dio(BaseOptions(baseUrl: 'https://${KakaoSdk.hosts.kapi}'))
      ..httpClientAdapter = adapter;
    final client = KakaoDioHttpClient(dio: dio);

    await expectLater(
      client.get('/v1/not-found'),
      throwsA(
        isA<KakaoClientException>().having(
          (e) => e.reason,
          'reason',
          ClientErrorCause.notSupported,
        ),
      ),
    );
  });

  test('kauth host error maps to KakaoAuthException', () async {
    final adapter = FakeHttpClientAdapter()
      ..mockFirstRequestFails = true
      ..errorStatusCode = 400
      ..errorData = {
        'error': 'invalid_client',
        'error_description': 'invalid app key',
      };
    final dio = Dio(BaseOptions(baseUrl: 'https://${KakaoSdk.hosts.kauth}'))
      ..httpClientAdapter = adapter;
    final client = KakaoDioHttpClient(dio: dio);

    await expectLater(
      client.get('/oauth/token'),
      throwsA(
        isA<KakaoAuthException>()
            .having((e) => e.error, 'error', AuthErrorCause.invalidClient)
            .having(
              (e) => e.errorDescription,
              'errorDescription',
              'invalid app key',
            ),
      ),
    );
  });

  test('kapi host error maps to KakaoApiException', () async {
    final adapter = FakeHttpClientAdapter()
      ..mockFirstRequestFails = true
      ..errorStatusCode = 403
      ..errorData = {
        'code': -402,
        'msg': 'insufficient scope',
        'required_scopes': ['friends'],
      };
    final dio = Dio(BaseOptions(baseUrl: 'https://${KakaoSdk.hosts.kapi}'))
      ..httpClientAdapter = adapter;
    final client = KakaoDioHttpClient(dio: dio);

    await expectLater(
      client.get('/v1/user/scopes'),
      throwsA(
        isA<KakaoApiException>()
            .having((e) => e.code, 'code', ApiErrorCause.insufficientScope)
            .having((e) => e.requiredScopes, 'requiredScopes', ['friends']),
      ),
    );
  });
}
