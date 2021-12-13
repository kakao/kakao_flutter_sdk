import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  test("spread", () async {
    var finalData = {"key1": "value1", ...{}};
    expect(finalData, {"key1": "value1"});
  });
}
