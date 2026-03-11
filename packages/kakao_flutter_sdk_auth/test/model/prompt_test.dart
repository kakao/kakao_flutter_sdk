import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/model/prompt.dart';

void main() {
  group('Prompt', () {
    test('should have correct values', () {
      expect(Prompt.login.value, 'login');
      expect(Prompt.create.value, 'create');
      expect(Prompt.selectAccount.value, 'select_account');
    });

    test('should have all expected prompt types', () {
      expect(Prompt.values.length, 3);
      expect(Prompt.values, contains(Prompt.login));
      expect(Prompt.values, contains(Prompt.create));
      expect(Prompt.values, contains(Prompt.selectAccount));
    });

    test('should be able to iterate through all values', () {
      final values = Prompt.values.map((p) => p.value).toList();
      expect(values, ['login', 'create', 'select_account']);
    });
  });
}
