import 'dart:math';

/// @nodoc
extension StringExtension on String {
  String keepWord() {
    final RegExp emoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    String fullText = '';
    final words = split(' ');
    for (var i = 0; i < words.length; i++) {
      fullText += emoji.hasMatch(words[i])
          ? words[i]
          : words[i].replaceAllMapped(
              RegExp(r'(\S)(?=\S)'),
              (m) => '${m[1]}\u200D',
            );
      if (i < words.length - 1) fullText += ' ';
    }
    return fullText;
  }
}

String generateRandomString(int length) {
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final r = Random();
  return String.fromCharCodes(
    Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))),
  );
}
