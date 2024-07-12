import 'dart:math';

/// @nodoc
String generateRandomString(int length) {
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random r = Random();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}

/// @nodoc
extension ListParameterExtension<T> on List<T>? {
  String? joinToString([String separator = ""]) {
    if (this == null || this!.isEmpty) return null;

    return this!.join(separator);
  }
}
