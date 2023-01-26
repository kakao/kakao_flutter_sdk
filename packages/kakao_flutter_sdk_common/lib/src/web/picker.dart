import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';

Future<Map> createPickerParams(
  String pickerType,
  String transId,
  String accessToken,
  Map<String, dynamic> pickerParams,
) async {
  Map<String, dynamic> params = {
    'transId': transId,
    'appKey': KakaoSdk.appKey,
    'ka': await KakaoSdk.kaHeader,
    'token': accessToken,
  };
  pickerParams.forEach((key, value) => params[key] = value);
  params.removeWhere((k, v) => v == null);
  return params;
}

html.IFrameElement createIFrame(String transId, String source) {
  var iframe = html.document.createElement('iframe') as html.IFrameElement;
  iframe.id = transId;
  iframe.name = transId;
  iframe.src = '$source/proxy?transId=$transId';
  iframe.setAttribute(
    'style',
    'border:none; width:0; height:0; display:none; overflow:hidden;',
  );
  return iframe;
}

Future<String> addMessageEvent(
  String requestDomain,
  Completer<String> completer,
) {
  html.EventListener? callback;

  callback = (event) {
    if (event is html.MessageEvent) {
      if (event.data != null && event.origin == requestDomain) {
        html.window.removeEventListener('message', callback);
        Map response = jsonDecode(event.data);

        // picker error
        if (response.containsKey('code')) {
          return completer.completeError(event.data);
        }
        return completer.complete(event.data);
      }
    }
    return completer.completeError(PlatformException(code: 'error'));
  };

  html.window.addEventListener('message', callback);
  return completer.future;
}

void submitForm(String url, Map pickerParams, {String popupName = ''}) {
  final form = html.document.createElement('form') as html.FormElement;
  form.setAttribute('accept-charset', 'utf-8');
  form.setAttribute('method', 'post');
  form.setAttribute('action', url);
  form.setAttribute('target', popupName);
  form.setAttribute('style', 'display:none');

  pickerParams.forEach((key, value) {
    final input = html.document.createElement('input') as html.InputElement;
    input.type = 'hidden';
    input.name = key;
    input.value = value is String ? value : jsonEncode(value);
    form.append(input);
  });
  html.document.body!.append(form);
  form.submit();
  form.remove();
}
