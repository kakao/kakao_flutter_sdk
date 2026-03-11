import 'dart:convert';
import 'dart:io';

String uriPathToFilePath(String uri) {
  if (uri.startsWith('/')) {
    uri = uri.substring(1);
  }
  return uri.replaceAll('/', '_');
}

Future<String> loadJson(String path) async {
  final rootDir = _findProjectRoot();
  final file = File('${rootDir.path}/kakao-sdk-test-data/$path');
  return file.readAsString();
}

Future<Map<String, dynamic>> loadJsonIntoMap(String path) async {
  return jsonDecode(await loadJson(path));
}

Directory _findProjectRoot() {
  var current = Directory.current.absolute;

  while (true) {
    if (Directory('${current.path}/kakao-sdk-test-data').existsSync()) {
      return current;
    }

    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError(
        'Could not find project root containing kakao-sdk-test-data from ${Directory.current.path}',
      );
    }
    current = parent;
  }
}
