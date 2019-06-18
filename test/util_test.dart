import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  test("spread", () async {
    var nullData;
    var finalData = {
      "key1": "value1",
      ...(nullData == null ? {} : {"key2": "value2"})
    };
    expect(finalData, {"key1": "value1"});
  });
}
