import 'dart:io';

import 'lib/release_utils.dart';

void main(List<String> arguments) {
  final projectRootDir = projectRootFromScript(Platform.script);

  try {
    final version = resolveVersion(arguments);
    updateSdkVersion(projectRootDir, version);
    final packageNames = loadWorkspacePackageNames(
      projectRootDir,
      publishableOnly: true,
    );

    for (final packageName in packageNames) {
      _bumpVersion(projectRootDir, packageName, version);
    }

    stdout.writeln('\nAll packages version bumping is successfully finished!');
  } catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}

String resolveVersion(List<String> arguments) {
  if (arguments.isEmpty) {
    throw Exception('Usage: dart run scripts/bump_version.dart <version>');
  }

  final version = arguments.first.trim();
  final semverPattern = RegExp(
    r'^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$',
  );

  if (!semverPattern.hasMatch(version) || version == '0.0.0') {
    throw Exception(
      'Version must use semver format: X.Y.Z, X.Y.Z-pre, or X.Y.Z+build',
    );
  }

  return version;
}

void _bumpVersion(String rootDir, String packageName, String version) {
  stdout.writeln('\nBump version $packageName to $version...');

  final manager = SdkPubspecManager(rootDir, packageName);

  manager.updateVersion(version);
  manager.updateDependencyVersions(version);

  stdout.writeln('$packageName version bumping finished!');
}

class SdkPubspecManager {
  final File pubspec;

  SdkPubspecManager(String rootDir, String packageName)
    : pubspec = File('$rootDir/packages/$packageName/pubspec.yaml');

  void updateVersion(String version) {
    _editPubspec((buffer, line) {
      if (line.trim().startsWith('version:')) {
        buffer.writeln('version: $version');
        return;
      }

      buffer.writeln(line);
    });
  }

  void updateDependencyVersions(String version) {
    final depPattern = RegExp(
      r'^(\s+)(kakao_flutter_sdk\w*):\s*\^([0-9A-Za-z.+-]+)(.*)$',
    );

    _editPubspec((buffer, line) {
      final match = depPattern.firstMatch(line);
      if (match != null) {
        final indent = match.group(1)!;
        final dep = match.group(2)!;
        buffer.writeln('$indent$dep: ^$version');
      } else {
        buffer.writeln(line);
      }
    });
  }

  void _editPubspec(Function(StringBuffer buffer, String line) block) {
    if (!pubspec.existsSync()) {
      throw Exception('yaml File not found');
    }

    final lines = pubspec.readAsLinesSync();
    final buffer = StringBuffer();

    for (final line in lines) {
      block(buffer, line);
    }
    pubspec.writeAsStringSync(buffer.toString());
  }
}
