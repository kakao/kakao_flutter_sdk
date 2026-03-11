import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

import 'browser_detector.dart';

/// @nodoc
bool isMobileWeb() {
  return isAndroidWeb() || isiOSWeb();
}

/// @nodoc
bool isAndroidWeb() {
  return defaultTargetPlatform == TargetPlatform.android;
}

/// @nodoc
bool isiOSWeb() {
  return defaultTargetPlatform == TargetPlatform.iOS;
}

/// @nodoc
void submitForm(String url, Map<String, dynamic> params, {String popupName = ''}) {
  final form = document.createElement('form') as HTMLFormElement
    ..setAttribute('accept-charset', 'utf-8')
    ..setAttribute('method', 'post')
    ..setAttribute('action', url)
    ..setAttribute('target', popupName)
    ..setAttribute('style', 'display:none');

  params.forEach((key, value) {
    final input = document.createElement('input') as HTMLInputElement
      ..type = 'hidden'
      ..name = key
      ..value = value is String ? value : jsonEncode(value);
    form.append(input);
  });
  document.body!.append(form);
  form.submit();
  form.remove();
}

/// @nodoc
HTMLIFrameElement createHiddenIframe(String transId, String source) {
  return document.createElement('iframe') as HTMLIFrameElement
    ..id = transId
    ..name = transId
    ..src = source
    ..setAttribute(
      'style',
      'border:none; width:0; height:0; display:none; overflow:hidden;',
    );
}

/// @nodoc
EventListener addMessageEventListener(
  Browser browser,
  String requestDomain,
  Completer<String> completer,
  Function afterReceive,
) {
  EventListener? callback;

  callback = (MessageEvent event) {
    if (completer.isCompleted) return;

    if (event.data != null &&
        (event.origin == requestDomain ||
            (isiOSWeb() &&
                browser == Browser.kakaotalk &&
                event.origin == window.origin))) {
      window.removeEventListener('message', callback);

      completer.complete(event.data.toString());
      afterReceive();
      return;
    }
  }.toJS;

  window.addEventListener('message', callback);
  return callback;
}
