import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_context.dart';
import 'package:kakao_flutter_sdk/src/link/link_api.dart';
import 'package:kakao_flutter_sdk/src/link/model/link_response.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';
import 'package:platform/platform.dart';

const _channel = MethodChannel("kakao_flutter_sdk");

class LinkClient {
  LinkClient(this.api, {Platform platform})
      : _platform = platform ?? LocalPlatform();
  LinkApi api;
  Platform _platform;

  static final LinkClient instance = LinkClient(LinkApi.instance);

  Future<Uri> customWithWeb(int templateId,
      {Map<String, String> templateArgs,
      Map<String, String> serverCallbackArgs}) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return sharerWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  Future<Uri> defaultWithWeb(DefaultTemplate template,
      {Map<String, String> serverCallbackArgs}) async {
    final response = await api.defaultTemplate(template);
    return sharerWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  Future<Uri> scrapWithWeb(String url,
      {int templateId,
      Map<String, String> templateArgs,
      Map<String, String> serverCallbackArgs}) async {
    final response = await api.scrap(url,
        templateId: templateId, templateArgs: templateArgs);
    return sharerWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  Future<Uri> customWithTalk(int templateId,
      {Map<String, String> templateArgs,
      Map<String, String> serverCallbackArgs}) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  Future<Uri> defaultWithTalk(DefaultTemplate template,
      {Map<String, String> serverCallbackArgs}) async {
    final response = await api.defaultTemplate(template);
    return talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  Future<Uri> scrapWithTalk(String url,
      {int templateId,
      Map<String, String> templateArgs,
      Map<String, String> serverCallbackArgs}) async {
    final response = await api.scrap(url,
        templateId: templateId, templateArgs: templateArgs);
    return talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  Future<Uri> sharerWithResponse(LinkResponse response,
      {Map<String, String> serverCallbackArgs}) async {
    final params = {
      "app_key": KakaoContext.clientId,
      "ka": await KakaoContext.kaHeader,
      "validation_action": "custom",
      "validation_params": jsonEncode({
        "template_id": response.templateId,
        "template_args": response.templateArgs,
        "link_ver": "4.0"
      }),
      "lcba": serverCallbackArgs == null ? null : jsonEncode(serverCallbackArgs)
    };

    params.removeWhere((k, v) => v == null);
    return Uri.https(
        KakaoContext.hosts.sharer, "talk/friends/picker/easylink", params);
  }

  Future<Uri> talkWithResponse(LinkResponse response,
      {String clientId, Map<String, String> serverCallbackArgs}) async {
    final attachmentSize = await _attachmentSize(response,
        clientId: clientId, serverCallbackArgs: serverCallbackArgs);
    if (attachmentSize > 10 * 1024) {
      throw KakaoClientException(
          "Exceeded message template v2 size limit (${attachmentSize / 1024}kb > 10kb).");
    }
    Map<String, String> params = {
      "linkver": "4.0",
      "appkey": clientId ?? KakaoContext.clientId,
      "appver": await KakaoContext.appVer,
      "template_id": response.templateId.toString(),
      "template_args": jsonEncode(response.templateArgs),
      "template_json": jsonEncode(response.templateMsg),
      "extras": jsonEncode(await _extras(serverCallbackArgs))
    };
    return Uri(scheme: "kakaolink", host: "send", queryParameters: params);
  }

  Future<void> launchKakaoTalk(Uri uri) {
    return _channel.invokeMethod("launchKakaoTalk", {"uri": uri.toString()});
  }

  Future<Map<String, String>> _extras(
      [Map<String, String> serverCallbackArgs]) async {
    Map<String, String> extras = {
      "KA": await KakaoContext.kaHeader,
      "lcba":
          serverCallbackArgs == null ? null : jsonEncode(serverCallbackArgs),
      ...(_platform.isAndroid
          ? {
              "appPkg": await KakaoContext.packageName,
              "keyHash": await KakaoContext.origin
            }
          : _platform.isIOS ? {"iosBundleId": await KakaoContext.origin} : {}),
    };
    extras.removeWhere((k, v) => v == null);
    return extras;
  }

  Future<int> _attachmentSize(LinkResponse response,
      {String clientId, Map<String, String> serverCallbackArgs}) async {
    final templateMsg = response.templateMsg;
    final attachment = {
      "lv": "4.0",
      "av": "4.0",
      "ak": clientId ?? KakaoContext.clientId,
      "P": templateMsg["P"],
      "C": templateMsg["C"],
      "template_id": response.templateId,
      "template_args": response.templateArgs,
      "extras": jsonEncode(await _extras(serverCallbackArgs))
    };
    return utf8.encode(jsonEncode(attachment)).length;
  }
}
