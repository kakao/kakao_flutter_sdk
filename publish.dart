import 'dart:io';

const sdkName = 'kakao_flutter_sdk';
const packageList = [
  '_common',
  '_auth',
  '_navi',
  '_template',
  '_share',
  '_user',
  '_friend',
  '_talk',
  ''
];

void main() {
  try {
    final version = getSdkVersion();

    // KakaoSdk.dart 파일 sdkVersion 변경
    updateSdkVersion(version);

    final backupDir = initializeBackupDirectory();

    for (final package in packageList) {
      final packageName = '$sdkName$package';

      if (!Directory('packages/$packageName').existsSync()) {
        stdout.writeln('Skipping $packageName (not found)');
        continue;
      }

      _publishPackage(packageName, version, backupDir);
    }

    _cleanupBackupDirectory(backupDir);

    stdout.writeln('\nAll packages published successfully!');
  } catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}

void updateSdkVersion(String version) {
  final kakaoSdkFile =
      File('packages/kakao_flutter_sdk_common/lib/src/kakao_sdk.dart');
  if (kakaoSdkFile.existsSync()) {
    var source = kakaoSdkFile.readAsStringSync();

    source = source.replaceFirst(
      RegExp(r'static String sdkVersion .*'),
      "static String sdkVersion = '$version';",
    );
    kakaoSdkFile.writeAsStringSync(source);
  }
}

String getSdkVersion() {
  // 현재 브랜치 확인

  final branchResult = Process.runSync('git', ['branch', '--show-current']);
  final branch = (branchResult.stdout as String).trim();

  if (!branch.startsWith('release') && !branch.startsWith('hotfix')) {
    throw Exception('The current branch must be release or hotfix!');
  }

  return branch.split('/').last;
}

Directory initializeBackupDirectory() {
  final backupDir = Directory('backup');

  if (backupDir.existsSync()) {
    backupDir.deleteSync(recursive: true);
  }
  backupDir.createSync();

  return backupDir;
}

void _publishPackage(String packageName, String version, Directory backupDir) {
  stdout.writeln('\nProcessing $packageName...');

  final manager = SdkPubspecManager(packageName);

  manager.updateVersion(version);
  manager.backup(backupDir.path);

  _copyDocuments(packageName);

  manager.updateDependency(version);

  _publish(packageName);

  manager.restore(backupDir.path);

  _removeDocuments(packageName);

  stdout.writeln('$packageName published successfully!');
}

void _publish(String packageName) {
  final result = Process.runSync(
    'flutter',
    ['pub', 'publish', '-f'],
    workingDirectory: 'packages/$packageName',
  );

  if (result.exitCode != 0) {
    throw Exception('Failed to publish $packageName');
  }
}

void _copyDocuments(String packageName) {
  File('README.md').copySync('packages/$packageName/README.md');
  File('CHANGELOG.md').copySync('packages/$packageName/CHANGELOG.md');
}

void _removeDocuments(String packageName) {
  final readme = File('packages/$packageName/README.md');
  final changelog = File('packages/$packageName/CHANGELOG.md');

  if (readme.existsSync()) readme.deleteSync();
  if (changelog.existsSync()) changelog.deleteSync();
}

void _cleanupBackupDirectory(Directory backupDir) {
  if (backupDir.existsSync()) {
    backupDir.deleteSync(recursive: true);
  }
}

class SdkPubspecManager {
  final String packageName;
  final File pubspec;

  SdkPubspecManager(this.packageName)
      : pubspec = File('packages/$packageName/pubspec.yaml');

  void updateVersion(String version) {
    _editPubspec((buffer, line) {
      if (line.trim().startsWith('version:')) {
        buffer.writeln('version: $version');
        return;
      }

      buffer.writeln(line);
    });
  }

  void updateDependency(String version) {
    _editPubspec((buffer, line) {
      if (line.contains('path:')) {
        return;
      }

      if (line.contains('kakao_flutter_sdk_') && line.trim().endsWith(':')) {
        buffer.writeln('$line $version');
        print('line: $line $version');
        return;
      }

      buffer.writeln(line);
    });
  }

  void backup(String backupDirPath) {
    final packageBackupDir = Directory('$backupDirPath/$packageName');

    if (!packageBackupDir.existsSync()) {
      packageBackupDir.createSync(recursive: true);
    }

    if (pubspec.existsSync()) {
      pubspec.copySync('$backupDirPath/$packageName/pubspec.yaml');
    }
  }

  void restore(String backupDirPath) {
    final backupFile = File('$backupDirPath/$packageName/pubspec.yaml');

    if (!backupFile.existsSync()) {
      throw Exception('Backup file not found for $packageName');
    }

    backupFile.copySync(pubspec.path);
  }

  void _editPubspec(Function(StringBuffer buffer, String line) block) {
    if (!pubspec.existsSync()) {
      throw Exception('yaml File not found');
    }

    final lines = pubspec.readAsLinesSync();
    final buffer = StringBuffer();

    for (var line in lines) {
      block(buffer, line);
    }
    pubspec.writeAsStringSync(buffer.toString());
  }
}
