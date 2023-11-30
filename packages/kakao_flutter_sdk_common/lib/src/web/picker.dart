import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

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

html.EventListener addMessageEventListener(
  String requestDomain,
  Completer<String> completer,
) {
  callback(event) {
    if (event is! html.MessageEvent) return;

    if (event.data != null && event.origin == requestDomain) {
      Map response = jsonDecode(event.data);

      // picker error
      if (response.containsKey('code')) {
        completer.completeError(event.data);
      }
      completer.complete(event.data);
    }
  }

  html.window.addEventListener('message', callback);
  return callback;
}
