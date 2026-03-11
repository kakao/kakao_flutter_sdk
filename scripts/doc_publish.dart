import 'dart:io';

import 'lib/release_utils.dart';

const _nexusHost = 'https://devrepo.kakao.com';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stderr.writeln('No arguments supplied');
    exit(1);
  }

  final version = arguments[0];
  final versionPattern = RegExp(
    r'^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$',
  );

  if (!versionPattern.hasMatch(version) || version == '0.0.0') {
    stderr.writeln(
      'The version code format is X.Y.Z, X.Y.Z-pre, or X.Y.Z+build',
    );
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

  final projectRootDir = projectRootFromScript(Platform.script);

  try {
    // README 파일 복사
    stdout.writeln('Copying README.md...');
    File(
      '$projectRootDir/README.md',
    ).copySync('$projectRootDir/packages/kakao_flutter_sdk/README.md');

    generateDoc(projectRootDir);

    stdout.writeln('Editing documentation links...');

    // 레퍼런스 링크 수정 (dartdoc 8.3.0 버전부터 패키지 루트 문서가 index.html로 생성되어 링크 수정 필요)
    editDocLinks('$projectRootDir/packages/kakao_flutter_sdk/doc/api');

    zipProject(rootDir: projectRootDir, version: version);

    // nexus 업로드
    upload(
      repository: repository,
      version: version,
      finalVersion: finalVersion,
    );

    // 파일 삭제
    cleanup(rootDir: projectRootDir, version: version);

    stdout.writeln('Documentation published successfully!');
  } catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}

void generateDoc(String rootDir) {
  stdout.writeln('Generating documentation...');

  final dartdocResult = Process.runSync('dart', [
    'run',
    'dartdoc',
    '--no-link-to-remote',
  ], workingDirectory: '$rootDir/packages/kakao_flutter_sdk');

  if (dartdocResult.exitCode != 0) {
    throw Exception('dartdoc failed: ${dartdocResult.stderr}');
  }
}

void zipProject({required String rootDir, required String version}) {
  stdout.writeln('Creating zip archive...');

  final zipResult = Process.runSync('zip', [
    '-q',
    '-r',
    '$rootDir/kakao-flutter-sdk-doc-$version.zip',
    '.',
  ], workingDirectory: '$rootDir/packages/kakao_flutter_sdk/doc/api');

  if (zipResult.exitCode != 0) {
    throw Exception('zip failed: ${zipResult.stderr}');
  }
}

void upload({
  required String repository,
  required String version,
  required String finalVersion,
}) {
  stdout.writeln('Uploading to Nexus...');
  final settingsDir = Directory.systemTemp.createTempSync('kakao-nexus-');
  final settingsFile = createTempMavenSettings(
    repository: repository,
    targetDirectory: settingsDir,
  );

  try {
    final mvnResult = Process.runSync('mvn', [
      '--settings',
      settingsFile.path,
      'deploy:deploy-file',
      '-e',
      '-DgroupId=com.kakao.sdk',
      '-DartifactId=kakao-flutter-sdk-doc',
      '-Dversion=$finalVersion',
      '-Dpackaging=zip',
      '-DrepositoryId=kakaodev-$repository',
      '-Durl=$_nexusHost/nexus/content/repositories/kakaodev-$repository',
      '-Dfile=kakao-flutter-sdk-doc-$version.zip',
    ]);

    if (mvnResult.exitCode != 0) {
      final stdoutText = (mvnResult.stdout ?? '').toString().trim();
      final stderrText = (mvnResult.stderr ?? '').toString().trim();
      throw Exception(
        'mvn deploy failed '
        '(exit code ${mvnResult.exitCode})\n'
        'stdout:\n$stdoutText\n'
        'stderr:\n$stderrText',
      );
    }
  } finally {
    if (settingsDir.existsSync()) {
      settingsDir.deleteSync(recursive: true);
    }
  }
}

File createTempMavenSettings({
  required String repository,
  required Directory targetDirectory,
}) {
  final username = Platform.environment['NEXUS_USERNAME']?.trim();
  final password = Platform.environment['NEXUS_PASSWORD']?.trim();

  if (username == null || username.isEmpty) {
    throw Exception('NEXUS_USERNAME environment variable is required');
  }

  if (password == null || password.isEmpty) {
    throw Exception('NEXUS_PASSWORD environment variable is required');
  }

  final settingsFile = File('${targetDirectory.path}/settings.xml');
  final serverId = 'kakaodev-$repository';

  settingsFile.writeAsStringSync('''<settings>
  <servers>
    <server>
      <id>${xmlEscape(serverId)}</id>
      <username>${xmlEscape(username)}</username>
      <password>${xmlEscape(password)}</password>
    </server>
  </servers>
</settings>
''');

  return settingsFile;
}

String xmlEscape(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

void cleanup({required String version, required String rootDir}) {
  stdout.writeln('Cleaning up...');
  File('$rootDir/packages/kakao_flutter_sdk/README.md').deleteSync();
  Directory(
    '$rootDir/packages/kakao_flutter_sdk/doc',
  ).deleteSync(recursive: true);
  File('$rootDir/kakao-flutter-sdk-doc-$version.zip').deleteSync();
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

    html = html.replaceAllMapped(pattern, (Match match) {
      final prefix = match.group(1) ?? '';
      final libraryPath = match.group(2)!;
      final newLink = 'href="$prefix$libraryPath/index.html"';

      totalReplacementCount++;
      return newLink;
    });

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
