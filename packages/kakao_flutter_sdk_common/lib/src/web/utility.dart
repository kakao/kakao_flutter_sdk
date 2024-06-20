import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_common/src/util.dart';
import 'package:kakao_flutter_sdk_common/src/web/ua_parser.dart';
import 'package:web/web.dart' as web;

/// @nodoc
bool isMobileDevice() {
  return isAndroid() || isiOS();
}

void submitForm(String url, Map params, {String popupName = ''}) {
  final form = web.document.createElement('form') as web.HTMLFormElement;
  form.setAttribute('accept-charset', 'utf-8');
  form.setAttribute('method', 'post');
  form.setAttribute('action', url);
  form.setAttribute('target', popupName);
  form.setAttribute('style', 'display:none');

  params.forEach((key, value) {
    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'hidden';
    input.name = key;
    input.value = value is String ? value : jsonEncode(value);
    form.append(input);
  });
  web.document.body!.append(form);
  form.submit();
  form.remove();
}

web.HTMLIFrameElement createHiddenIframe(String transId, String source) {
  return web.document.createElement('iframe') as web.HTMLIFrameElement
    ..id = transId
    ..name = transId
    ..src = source
    ..setAttribute(
      'style',
      'border:none; width:0; height:0; display:none; overflow:hidden;',
    );
}

web.EventListener addMessageEventListener(
  Browser browser,
  String requestDomain,
  Completer<String> completer,
  Function afterReceive,
) {
  web.EventListener? callback;

  callback = (web.Event event) {
    if (event is! web.MessageEvent || completer.isCompleted) return;

    if (event.data != null &&
        (event.origin == requestDomain ||
            (isiOS() &&
                browser == Browser.kakaotalk &&
                event.origin == web.window.origin))) {
      web.window.removeEventListener('message', callback);

      completer.complete(event.data.toString());
      afterReceive();
      return;
    }
  }.toJS;

  web.window.addEventListener('message', callback);
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
    String baseUri = _removeEndSlash(web.window.document.baseURI);
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

extension WindowExtension on web.Window {
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
