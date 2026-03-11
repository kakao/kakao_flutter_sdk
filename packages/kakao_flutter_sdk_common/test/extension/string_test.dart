import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  group('String extension test', () {
    test('keepWord test', () {
      // 일반 텍스트 테스트
      final text1 = 'Hello';
      final result1 = text1.keepWord();
      expect(result1, 'H\u200De\u200Dl\u200Dl\u200Do');

      // 공백이 포함된 텍스트
      final text2 = 'Hello World';
      final result2 = text2.keepWord();
      expect(
        result2,
        'H\u200De\u200Dl\u200Dl\u200Do W\u200Do\u200Dr\u200Dl\u200Dd',
      );

      // 이모지 포함 텍스트
      final text3 = 'Hello 😀 World';
      final result3 = text3.keepWord();
      expect(result3.contains('😀'), isTrue);
      expect(result3.contains('\u200D'), isTrue);

      // 특수문자 테스트
      final text4 = 'test@123';
      final result4 = text4.keepWord();
      expect(result4.contains('\u200D'), isTrue);

      // 빈 문자열
      final text5 = '';
      final result5 = text5.keepWord();
      expect(result5, '');
    });

    test('generateRandomString test', () {
      final length = 10;
      final randomString = generateRandomString(length);
      expect(randomString.length, length);
      final regex = RegExp(r'^[a-zA-Z0-9]+$');
      expect(regex.hasMatch(randomString), isTrue);
    });
  });
}
