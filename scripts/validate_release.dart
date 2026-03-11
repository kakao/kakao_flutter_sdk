import 'dart:convert';
import 'dart:io';

import 'lib/release_utils.dart';

Future<void> main(List<String> arguments) async {
  final projectRootDir = projectRootFromScript(Platform.script);

  try {
    final version = _resolveVersion(arguments);

    _assertOnMaster(rootDir: projectRootDir);
    _assertVersionsMatch(rootDir: projectRootDir, version: version);
    _assertChangelogContains(rootDir: projectRootDir, version: version);
    await _assertVersionNotPublished(rootDir: projectRootDir, version: version);

    stdout.writeln('Release validation passed for $version');
  } catch (e) {
    stderr.writeln('Release validation failed: $e');
    exit(1);
  }
}

String _resolveVersion(List<String> arguments) {
  if (arguments.isEmpty) {
    throw ArgumentError(
      'Usage: dart run scripts/validate_release.dart <tag-or-version>',
    );
  }

  final raw = arguments.first.trim();
  final version = raw.startsWith('refs/tags/')
      ? raw.substring('refs/tags/'.length)
      : raw;
  final semverPattern = RegExp(
    r'^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$',
  );

  if (!semverPattern.hasMatch(version)) {
    throw ArgumentError(
      'Release tag must use X.Y.Z, X.Y.Z-pre, X.Y.Z+build, or X.Y.Z-pre+build format.',
    );
  }

  return version;
}

void _assertOnMaster({required String rootDir}) {
  final result = Process.runSync('git', [
    'branch',
    '--remotes',
    '--contains',
    'HEAD',
  ], workingDirectory: rootDir);

  if (result.exitCode != 0) {
    throw StateError('Failed to inspect remote branches: ${result.stderr}');
  }

  final branches = (result.stdout as String)
      .split('\n')
      .map((line) => line.replaceAll('*', '').trim())
      .where((line) => line.isNotEmpty)
      .toList();

  if (!branches.contains('origin/master')) {
    throw StateError(
        'Release tag must point to a commit reachable from origin/master.');
  }
}

void _assertVersionsMatch({required String rootDir, required String version}) {
  final packageNames = loadWorkspacePackageNames(
    rootDir,
    publishableOnly: true,
  );

  for (final packageName in packageNames) {
    final pubspec = File('$rootDir/packages/$packageName/pubspec.yaml');
    final lines = pubspec.readAsLinesSync();
    final versionLine = lines.firstWhere(
      (line) => line.trim().startsWith('version:'),
      orElse: () => '',
    );

    if (versionLine.isEmpty) {
      throw StateError('Missing version in ${pubspec.path}');
    }

    final pubspecVersion = versionLine.split(':').last.trim();
    if (pubspecVersion != version) {
      throw StateError(
        'Version mismatch in ${pubspec.path}: expected $version, found $pubspecVersion',
      );
    }

    final internalDependencyPattern = RegExp(
      r'^\s+(kakao_flutter_sdk\w*):\s*\^([0-9A-Za-z.+-]+)\s*$',
    );

    for (final line in lines) {
      final match = internalDependencyPattern.firstMatch(line);
      if (match == null) continue;

      final dependencyVersion = match.group(2)!;
      if (dependencyVersion != version) {
        throw StateError(
          'Dependency mismatch in ${pubspec.path}: ${match.group(1)} expects ^$dependencyVersion',
        );
      }
    }
  }

  final sdkSource = File(
    '$rootDir/packages/kakao_flutter_sdk_common/lib/src/kakao_sdk.dart',
  ).readAsStringSync();
  final sdkVersionPattern = RegExp(r"static String sdkVersion\s*=\s*'([^']+)';");
  final match = sdkVersionPattern.firstMatch(sdkSource);

  if (match == null) {
    throw StateError('sdkVersion declaration not found.');
  }

  if (match.group(1) != version) {
    throw StateError(
      'sdkVersion mismatch: expected $version, found ${match.group(1)}',
    );
  }
}

void _assertChangelogContains({required String rootDir, required String version}) {
  final changelog = File('$rootDir/CHANGELOG.md').readAsStringSync();

  if (!changelog.contains(version)) {
    throw StateError('CHANGELOG.md does not mention version $version');
  }
}

Future<void> _assertVersionNotPublished({
  required String rootDir,
  required String version,
}) async {
  final packageNames = loadWorkspacePackageNames(
    rootDir,
    publishableOnly: true,
  );
  final client = HttpClient();

  try {
    for (final packageName in packageNames) {
      final uri = Uri.https('pub.dev', '/api/packages/$packageName');
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == HttpStatus.notFound) {
        continue;
      }

      if (response.statusCode != HttpStatus.ok) {
        throw StateError(
          'Failed to query pub.dev for $packageName: HTTP ${response.statusCode}',
        );
      }

      final body = await utf8.decoder.bind(response).join();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final versions = (data['versions'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((entry) => entry['version'] as String)
          .toSet();

      if (versions.contains(version)) {
        throw StateError('$packageName version $version is already published on pub.dev');
      }
    }
  } finally {
    client.close(force: true);
  }
}
