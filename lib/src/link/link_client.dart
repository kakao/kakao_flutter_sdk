import 'dart:async';
import 'dart:convert';

import 'package:kakao_flutter_sdk/src/kakao_context.dart';
import 'package:kakao_flutter_sdk/src/link/link_api.dart';
import 'package:kakao_flutter_sdk/src/link/model/link_response.dart';

class LinkClient {
  LinkClient(this.api);
  LinkApi api;

  static final LinkClient instance = LinkClient(LinkApi.instance);

  Future<Uri> custom(int templateId, Map<String, String> templateArgs,
      [Map<String, String> serverCallbackArgs]) async {
    var response = await api.custom(templateId, templateArgs);
    return customWithResponse(response, serverCallbackArgs);
  }

  Future<Uri> customWithResponse(LinkResponse response,
      [Map<String, String> serverCallbackArgs]) async {
    var params = {
      "app_key": KakaoContext.clientId,
      "ka": await KakaoContext.kaHeader,
      "validation_action": "custom",
      "validation_params": jsonEncode({
        "template_id": response.templateId,
        "template_args": response.templateArgs,
        "link_ver": "4.0"
      })
    };
    if (serverCallbackArgs != null) {
      params["lcba"] = jsonEncode(serverCallbackArgs);
    }
    return Uri.https(
        "sharer.kakao.com", "talk/friends/picker/easylink", params);
  }
}
