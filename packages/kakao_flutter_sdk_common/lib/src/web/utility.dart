import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_common/src/util.dart';

/// @nodoc
bool isMobileDevice() {
  return isAndroid() || isiOS();
}

/// @nodoc
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
    String baseUri = _removeEndSlash(window.document.baseUri!);
    var dio = Dio()..options.baseUrl = baseUri;
    Response<String> response = await dio.get(
      '${Uri.parse(baseUri).path}/version.json',
      queryParameters: {'cachebuster': cacheBuster},
    );
    return response.data!;
  }

  static String _removeEndSlash(String url) {
    if (url.endsWith('/')) {
      int length = url.length;
      return url.substring(0, length - 1);
    }
    return url;
  }
}
