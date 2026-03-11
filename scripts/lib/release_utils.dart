import 'dart:io';

const _sdkPrefix = 'kakao_flutter_sdk';

/// 스크립트 URI로부터 프로젝트 루트 경로를 계산합니다.
///
/// 스크립트가 `<root>/scripts/` 또는 `<root>/scripts/lib/`에 위치한 경우를
/// 모두 지원합니다.
String projectRootFromScript(Uri scriptUri) {
  final scriptDir = File.fromUri(scriptUri).parent;
  // scripts/lib/ 에서 실행 → 두 단계 위
  // scripts/ 에서 실행 → 한 단계 위
  if (scriptDir.path.endsWith('lib')) {
    return scriptDir.parent.parent.path;
  }
  return scriptDir.parent.path;
}

/// 루트 pubspec.yaml의 `workspace:` 섹션에서 패키지 이름 목록을 읽어옵니다.
///
/// [publishableOnly]가 true이면 `publish_to: none`인 패키지를 제외합니다.
List<String> loadWorkspacePackageNames(
  String rootDir, {
  bool publishableOnly = false,
}) {
  final rootPubspec = File('$rootDir/pubspec.yaml');
  if (!rootPubspec.existsSync()) {
    throw StateError('Workspace pubspec not found: ${rootPubspec.path}');
  }

  final lines = rootPubspec.readAsLinesSync();
  final workspacePaths = <String>[];
  var inWorkspace = false;

  for (final rawLine in lines) {
    final trimmed = rawLine.trim();

    if (!inWorkspace) {
      if (trimmed == 'workspace:') {
        inWorkspace = true;
      }
      continue;
    }

    // 빈 줄이나 주석은 건너뜀
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }

    // YAML 리스트 항목
    if (trimmed.startsWith('- ')) {
      workspacePaths.add(trimmed.substring(2).trim());
      continue;
    }

    // 들여쓰기 없는 새 섹션 시작 → workspace 섹션 종료
    if (!rawLine.startsWith(' ')) {
      break;
    }
  }

  final packageNames = workspacePaths
      .map(_packageNameFromPath)
      .where((name) => name.isNotEmpty && name.startsWith(_sdkPrefix))
      .toList();

  if (!publishableOnly) {
    return packageNames;
  }

  return packageNames
      .where((name) => _isPublishablePackage(rootDir, name))
      .toList(growable: false);
}

/// kakao_sdk.dart 파일의 sdkVersion 상수를 [version]으로 업데이트합니다.
void updateSdkVersion(String rootDir, String version) {
  final kakaoSdkFile = File(
    '$rootDir/packages/kakao_flutter_sdk_common/lib/src/kakao_sdk.dart',
  );
  if (!kakaoSdkFile.existsSync()) {
    throw StateError('File not found: ${kakaoSdkFile.path}');
  }

  var source = kakaoSdkFile.readAsStringSync();
  final pattern = RegExp(r"static String sdkVersion\s*=\s*'[^']*';");

  if (!pattern.hasMatch(source)) {
    throw StateError(
      'sdkVersion declaration not found in ${kakaoSdkFile.path}',
    );
  }

  source = source.replaceFirst(
    pattern,
    "static String sdkVersion = '$version';",
  );
  kakaoSdkFile.writeAsStringSync(source);
}

/// 공통 문서(README, CHANGELOG, LICENSE)를 지정 패키지 디렉토리로 복사합니다.
void copyDocuments(String rootDir, String packageName) {
  final packageDir = '$rootDir/packages/$packageName';

  File('$rootDir/README.md').copySync('$packageDir/README.md');
  File('$rootDir/CHANGELOG.md').copySync('$packageDir/CHANGELOG.md');
  File('$rootDir/LICENSE').copySync('$packageDir/LICENSE');
}

/// [copyDocuments]로 복사된 문서를 제거합니다.
void removeDocuments(String rootDir, String packageName) {
  final packageDir = '$rootDir/packages/$packageName';

  for (final name in ['README.md', 'CHANGELOG.md', 'LICENSE']) {
    final file = File('$packageDir/$name');
    if (file.existsSync()) file.deleteSync();
  }
}

/// workspace 경로에서 패키지 이름(마지막 세그먼트)을 추출합니다.
String _packageNameFromPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final segments = normalized.split('/')..removeWhere((s) => s.isEmpty);
  return segments.isEmpty ? '' : segments.last;
}

/// 패키지의 pubspec.yaml에 `publish_to: none`이 설정되어 있지 않은지 확인합니다.
bool _isPublishablePackage(String rootDir, String packageName) {
  final pubspec = File('$rootDir/packages/$packageName/pubspec.yaml');
  if (!pubspec.existsSync()) {
    return false;
  }

  for (final line in pubspec.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.startsWith('publish_to:')) {
      return trimmed != 'publish_to: none';
    }
  }

  return true;
}
