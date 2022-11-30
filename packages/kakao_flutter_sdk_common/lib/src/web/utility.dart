import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';

class Utility {
  static Future<String> getAppVersion() async {
    var json = await _getVersionJson();
    return jsonDecode(json)['version'];
  }

  static Future<String> getPackageName() async {
    var json = await _getVersionJson();
    return jsonDecode(json)['package_name'];
  }

  static Future<String> _getVersionJson() async {
    final cacheBuster = DateTime.now().millisecondsSinceEpoch;
    String baseUri = window.document.baseUri!;
    var dio = Dio()..options.baseUrl = window.document.baseUri!;
    Response<String> response = await dio.get(
      '${Uri.parse(baseUri).path}/version.json',
      queryParameters: {'cachebuster': cacheBuster},
    );
    return response.data!;
  }
}
