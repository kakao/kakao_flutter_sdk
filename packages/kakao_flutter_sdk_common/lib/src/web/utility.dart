import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_common/src/util.dart';

/// @nodoc
bool isMobileDevice() {
  return isAndroid() || isiOS();
}

void submitForm(String url, Map params, {String popupName = ''}) {
  final form = document.createElement('form') as FormElement;
  form.setAttribute('accept-charset', 'utf-8');
  form.setAttribute('method', 'post');
  form.setAttribute('action', url);
  form.setAttribute('target', popupName);
  form.setAttribute('style', 'display:none');

  params.forEach((key, value) {
    final input = document.createElement('input') as InputElement;
    input.type = 'hidden';
    input.name = key;
    input.value = value is String ? value : jsonEncode(value);
    form.append(input);
  });
  document.body!.append(form);
  form.submit();
  form.remove();
}

IFrameElement createHiddenIframe(String transId, String source) {
  return document.createElement('iframe') as IFrameElement
    ..id = transId
    ..name = transId
    ..src = source
    ..setAttribute(
      'style',
      'border:none; width:0; height:0; display:none; overflow:hidden;',
    );
}

EventListener addMessageEventListener(
    String requestDomain,
    Completer<String> completer,
    bool Function(Map response) isError,
    ) {
  callback(event) {
    if (event is! MessageEvent) return;

    if (event.data != null && event.origin == requestDomain) {
      if (isError(jsonDecode(event.data))) {
        completer.completeError(event.data);
      }
      completer.complete(event.data);
    }
  }

  window.addEventListener('message', callback);
  return callback;
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

extension WindowExtension on WindowBase {
  void afterClosed(Function() action, {checkIntervalSecond = 1}) {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: checkIntervalSecond));

      if (closed == true) {
        action();
        return false;
      }
      return true;
    });
  }
}
