import 'dart:io';

// dartdoc 생성 후, 문서 내의 라이브러리 링크를 수정하는 스크립트
void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stdout.writeln();
    exit(1);
  }

  final docDir = Directory(arguments[0]);

  if (!docDir.existsSync()) {
    stderr.writeln('Documentation directory not found: ${docDir.path}');
    exit(1);
  }

  stdout.writeln('Editing links in documentation files...');

  /*
  href="kakao_flutter_sdk_xxx/"
  href="../kakao_flutter_sdk_xxx/"
  href="../../kakao_flutter_sdk_xxx/"
  href="../../../kakao_flutter_sdk_xxx/"
   */
  final pattern = RegExp(r'href="((?:\.\./)*)(kakao_flutter_sdk[^"]*?)/"');

  int processedFileCount = 0;
  int modifiedFileCount = 0;
  int totalReplacementCount = 0;

  docDir.listSync(recursive: true).whereType<File>().forEach((File file) {
    if (!file.path.endsWith('.html')) {
      return;
    }

    processedFileCount++;
    String html = file.readAsStringSync();

    final matches = pattern.allMatches(html);
    if (matches.isEmpty) {
      return;
    }

    stdout.writeln('\n======= Processing: ${file.path} =======');

    int replacementCount = 0;
    html = html.replaceAllMapped(
      pattern,
      (Match match) {
        final prefix = match.group(1) ?? ''; // ../ 또는 빈 문자열
        final libraryPath = match.group(2)!;
        final oldLink = match.group(0)!;
        final newLink = 'href="$prefix$libraryPath/index.html"';

        stdout.writeln('  $oldLink -> $newLink');
        replacementCount++;
        totalReplacementCount++;
        return newLink;
      },
    );

    file.writeAsStringSync(html);
    modifiedFileCount++;
    stdout.writeln('Updated ${file.path} ($replacementCount replacements)');
  });

  stdout.writeln('\n=========== Completed ===========');
  stdout.writeln('      Processed files: $processedFileCount');
  stdout.writeln('      Modified files: $modifiedFileCount');
  stdout.writeln('      Total replacements: $totalReplacementCount');
  stdout.writeln('=================================\n');
}
