import 'dart:convert';
import 'dart:io';

import 'lib/release_utils.dart';

Future<void> main(List<String> arguments) async {
  final projectRootDir = projectRootFromScript(Platform.script);
  final packageNames = loadWorkspacePackageNames(
    projectRootDir,
    publishableOnly: true,
  );
  final dryRun = _resolveDryRun(arguments);
  final copiedPackages = <String>[];
  var hasFailure = false;

  stdout.writeln('Publish mode: ${dryRun ? 'dry-run' : 'real publish'}');
  try {
    for (final packageName in packageNames) {
      stdout.writeln('Copying documents for $packageName...');
      copyDocuments(projectRootDir, packageName);
      copiedPackages.add(packageName);
    }

    await _publish(rootDir: projectRootDir, dryRun: dryRun);

    stdout.writeln('\nAll packages published successfully!');
  } catch (e, st) {
    hasFailure = true;
    stderr.writeln('Publishing failed: $e');
    stderr.writeln(st);
  } finally {
    for (final packageName in copiedPackages) {
      stdout.writeln('Removing documents for $packageName...');
      removeDocuments(projectRootDir, packageName);
    }
  }

  if (hasFailure) {
    exit(1);
  }
}

Future<void> _publish({required String rootDir, required bool dryRun}) async {
  final process = await Process.start('dart', [
    'run',
    'melos',
    'publish',
    dryRun ? '--dry-run' : '--no-dry-run',
    '-y',
  ], workingDirectory: rootDir);

  final stdoutDone = process.stdout
      .transform(utf8.decoder)
      .forEach(stdout.write);
  final stderrDone = process.stderr
      .transform(utf8.decoder)
      .forEach(stderr.write);

  final exitCode = await process.exitCode;
  await Future.wait([stdoutDone, stderrDone]);

  if (exitCode != 0) {
    throw Exception('melos publish failed with exit code $exitCode');
  }
}


bool _resolveDryRun(List<String> arguments) {
  if (arguments.contains('--dry-run')) return true;
  if (arguments.contains('--no-dry-run')) return false;

  final env = Platform.environment['PUBLISH_DRY_RUN']?.toLowerCase();
  if (env == null) return true;

  return env == '1' || env == 'true' || env == 'yes';
}
