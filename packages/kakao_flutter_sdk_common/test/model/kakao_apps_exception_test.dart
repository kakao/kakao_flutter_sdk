import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  test('KakaoAppsException parses known app error response', () {
    final exception = KakaoAppsException.fromJson({
      'error_code': 'KAE001',
      'error_msg': 'internal error',
    });

    expect(exception.code, AppsErrorCause.internalServerError);
    expect(exception.msg, 'internal error');
    expect(exception.toJson(), {
      'error_code': 'KAE001',
      'error_msg': 'internal error',
    });
  });

  test('KakaoAppsException falls back to unknown on unrecognized code', () {
    final exception = KakaoAppsException.fromJson({
      'error_code': 'UNKNOWN',
      'error_msg': 'unknown',
    });

    expect(exception.code, AppsErrorCause.unknown);
    expect(exception.msg, 'unknown');
  });
}
