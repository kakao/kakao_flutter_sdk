import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  group('AESCipher test', () {
    test('key value length is less 16', () {
      final cipher = AESCipher.create(
        'test_key',
        Uint8List.fromList([1, 2, 3, 4, 5]),
      );

      final original = 'test_value';
      final encrypted = cipher.encrypt(original);
      final decrypted = cipher.decrypt(encrypted);

      expect(decrypted, original);
    });

    test('key value length is more 16', () {
      final cipher = AESCipher.create(
        'this_is_a_very_long_test_key_value',
        Uint8List.fromList([1, 2, 3, 4, 5]),
      );

      final original = 'another_test_value';
      final encrypted = cipher.encrypt(original);
      final decrypted = cipher.decrypt(encrypted);

      expect(decrypted, original);
    });
  });
}
