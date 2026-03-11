import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() {
  group('Map extension test', () {
    test('toJson, toEncodedJson, toQuery test', () {
      final map = {'key1': 'value1', 'key2': 'value2'};

      final json = map.toJson();
      expect(json, '{"key1":"value1","key2":"value2"}');

      final encodedJson = map.toEncodedJson();
      expect(
        encodedJson,
        '%7B%22key1%22%3A%22value1%22%2C%22key2%22%3A%22value2%22%7D',
      );

      final queryString = map.toQuery();
      expect(queryString, 'key1=value1&key2=value2');
    });
  });
}
