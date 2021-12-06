import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<String> loadJson(String path) async {
  return await File("../../test_resources/json/$path").readAsString();
}

Future<Map<String, dynamic>> loadJsonIntoMap(String path) async {
  return jsonDecode(await loadJson(path));
}
