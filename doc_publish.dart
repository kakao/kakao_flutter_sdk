import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stderr.writeln('No arguments supplied');
    exit(1);
  }

  final version = arguments[0];
  final versionPattern = RegExp(r'^\d+\.\d+\.\d+$');

  if (!versionPattern.hasMatch(version) || version == '0.0.0') {
    stderr.writeln('The version code format is *.*.*');
    exit(1);
  }

  if (arguments.length < 2 || arguments[1].isEmpty) {
    stderr.writeln("Pass the argument 'release' or 'snapshot'");
    exit(1);
  }

  final String repository;
  final String finalVersion;

  if (arguments[1] == 'release') {
    repository = 'releases';
    finalVersion = version;
  } else if (arguments[1] == 'snapshot') {
    repository = 'snapshots';
    finalVersion = '$version-SNAPSHOT';
  } else {
    stderr.writeln('The argument must be either "release" or "snapshot"');
    exit(1);
  }

  try {
    // README 파일 복사
    stdout.writeln('Copying README.md...');
    File('./README.md').copySync('packages/kakao_flutter_sdk/README.md');

    generateDoc();

    stdout.writeln('Editing documentation links...');

    // 레퍼런스 링크 수정 (dartdoc 8.3.0 버전부터 패키지 루트 문서가 index.html로 생성되어 링크 수정 필요)
    editDocLinks('packages/kakao_flutter_sdk/doc/api');

    zipProject(version);

    // nexus 업로드
    upload(repository, version, finalVersion);

    // 파일 삭제
    stdout.writeln('Cleaning up...');
    File('packages/kakao_flutter_sdk/README.md').deleteSync();
    Directory('packages/kakao_flutter_sdk/doc').deleteSync(recursive: true);
    File('kakao-flutter-sdk-doc-$version.zip').deleteSync();

    stdout.writeln('Documentation published successfully!');
  } catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}

void generateDoc() {
  stdout.writeln('Generating documentation...');

  final dartdocResult = Process.runSync(
    'dartdoc',
    ['--no-link-to-remote'],
    workingDirectory: 'packages/kakao_flutter_sdk',
  );

  if (dartdocResult.exitCode != 0) {
    throw Exception('dartdoc failed: ${dartdocResult.stderr}');
  }
}

void zipProject(String version) {
  stdout.writeln('Creating zip archive...');

  final zipResult = Process.runSync(
    'zip',
    ['-q', '-r', '../../../../kakao-flutter-sdk-doc-$version.zip', '.'],
    workingDirectory: 'packages/kakao_flutter_sdk/doc/api',
  );

  if (zipResult.exitCode != 0) {
    throw Exception('zip failed: ${zipResult.stderr}');
  }
}

void upload(String repository, String version, String finalVersion) {
  stdout.writeln('Uploading to Nexus...');

  final mvnResult = Process.runSync(
    'mvn',
    [
      'deploy:deploy-file',
      '-e',
      '-DgroupId=com.kakao.sdk',
      '-DartifactId=kakao-flutter-sdk-doc',
      '-Dversion=$finalVersion',
      '-Dpackaging=zip',
      '-DrepositoryId=kakaodev-$repository',
      '-Durl=https://devrepo.kakao.com/nexus/content/repositories/kakaodev-$repository',
      '-Dfile=kakao-flutter-sdk-doc-$version.zip',
    ],
  );

  if (mvnResult.exitCode != 0) {
    throw Exception('mvn deploy failed: ${mvnResult.stderr}');
  }
}

void editDocLinks(String docPath) {
  final docDir = Directory(docPath);

  if (!docDir.existsSync()) {
    throw Exception('Documentation directory not found: ${docDir.path}');
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

    // stdout.writeln('\n======= Processing: ${file.path} =======');

    int replacementCount = 0;
    html = html.replaceAllMapped(
      pattern,
      (Match match) {
        final prefix = match.group(1) ?? '';
        final libraryPath = match.group(2)!;
        final oldLink = match.group(0)!;
        final newLink = 'href="$prefix$libraryPath/index.html"';

        // stdout.writeln('  $oldLink -> $newLink');

        replacementCount++;
        totalReplacementCount++;
        return newLink;
      },
    );

    file.writeAsStringSync(html);
    modifiedFileCount++;
    // stdout.writeln('Updated ${file.path} ($replacementCount replacements)');
  });

  stdout.writeln('\n=========== Completed ===========');
  stdout.writeln('      Processed files: $processedFileCount');
  stdout.writeln('      Modified files: $modifiedFileCount');
  stdout.writeln('      Total replacements: $totalReplacementCount');
  stdout.writeln('=================================\n');
}
