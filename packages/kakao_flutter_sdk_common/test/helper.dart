import 'dart:async';
import 'dart:convert';
import 'dart:io';

String uriPathToFilePath(String uri) {
  if (uri.startsWith('/')) {
    uri = uri.substring(1);
  }
  return uri.replaceAll('/', '_');
}

Future<String> loadJson(String path) async {
  return await File("../../kakao-sdk-test-data/$path").readAsString();
}

Future<Map<String, dynamic>> loadJsonIntoMap(String path) async {
  return jsonDecode(await loadJson(path));
}
