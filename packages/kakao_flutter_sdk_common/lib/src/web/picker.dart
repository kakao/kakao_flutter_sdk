import 'dart:async';

import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';

Future<Map> createPickerParams(
  String accessToken,
  String transId,
  Map<String, dynamic> pickerParams,
) async {
  Map<String, dynamic> params = {
    'token': accessToken,
    'appKey': KakaoSdk.appKey,
    'ka': await KakaoSdk.kaHeader,
    'transId': transId,
  };
  pickerParams.forEach((key, value) => params[key] = value);
  params.removeWhere((k, v) => v == null);
  return params;
}
