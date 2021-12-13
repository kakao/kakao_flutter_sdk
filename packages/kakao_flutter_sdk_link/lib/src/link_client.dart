import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_link/src/link_api.dart';
import 'package:kakao_flutter_sdk_link/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_link/src/model/link_result.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

class LinkClient {
  LinkClient(this.api, {Platform? platform})
      : _platform = platform ?? LocalPlatform();
  LinkApi api;
  Platform _platform;

  static final MethodChannel _channel = MethodChannel("kakao_flutter_sdk");

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final LinkClient instance = LinkClient(LinkApi.instance);

  Future<bool> isKakaoLinkAvailable() async {
    return await _channel.invokeMethod('isKakaoLinkAvailable') ?? false;
  }

  /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 웹으로 공유.
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고.
  Future<Uri> customWithWeb(int templateId,
      {Map<String, String>? templateArgs,
      Map<String, String>? serverCallbackArgs}) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 기본 템플릿을 웹으로 공유.
  Future<Uri> defaultWithWeb(DefaultTemplate template,
      {Map<String, String>? serverCallbackArgs}) async {
    final response = await api.defaultTemplate(template);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드.
  /// 지정된 URL 을 스크랩하여 만들어진 템플릿을 웹으로 공유.
  Future<Uri> scrapWithWeb(String url,
      {int? templateId,
      Map<String, String>? templateArgs,
      Map<String, String>? serverCallbackArgs}) async {
    final response = await api.scrap(url,
        templateId: templateId, templateArgs: templateArgs);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오톡으로 공유.
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고.
  Future<Uri> customWithTalk(int templateId,
      {Map<String, String>? templateArgs,
      Map<String, String>? serverCallbackArgs}) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// 기본 템플릿을 카카오톡으로 공유.
  Future<Uri> defaultWithTalk(DefaultTemplate template,
      {Map<String, String>? serverCallbackArgs}) async {
    final response = await api.defaultTemplate(template);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드.
  /// 지정된 URL 을 스크랩하여 만들어진 템플릿을 카카오톡으로 공유.
  Future<Uri> scrapWithTalk(String url,
      {int? templateId,
      Map<String, String>? templateArgs,
      Map<String, String>? serverCallbackArgs}) async {
    final response = await api.scrap(url,
        templateId: templateId, templateArgs: templateArgs);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 로컬 이미지를 카카오 이미지 서버로 업로드.
  Future<ImageUploadResult> uploadImage(File image,
      {bool secureResource = true}) async {
    return await api.uploadImage(image, secureResource: secureResource);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드.
  Future<ImageUploadResult> scrapImage(String imageUrl,
      {bool secureResource = true}) async {
    return await api.scrapImage(imageUrl, secureResource: secureResource);
  }

  Future<void> launchKakaoTalk(Uri uri) {
    return _channel.invokeMethod("launchKakaoTalk", {"uri": uri.toString()});
  }

  Future<Uri> _sharerWithResponse(LinkResult response,
      {Map<String, String>? serverCallbackArgs}) async {
    final params = {
      "app_key": KakaoSdk.nativeKey,
      "ka": await KakaoSdk.kaHeader,
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
        KakaoSdk.hosts.sharer, "talk/friends/picker/easylink", params);
  }

  Future<Uri> _talkWithResponse(LinkResult response,
      {String? appKey, Map<String, String>? serverCallbackArgs}) async {
    final attachmentSize = await _attachmentSize(response,
        appKey: appKey, serverCallbackArgs: serverCallbackArgs);
    if (attachmentSize > 10 * 1024) {
      throw KakaoClientException(
          "Exceeded message template v2 size limit (${attachmentSize / 1024}kb > 10kb).");
    }
    Map<String, String> params = {
      "linkver": "4.0",
      "appkey": appKey ?? KakaoSdk.nativeKey,
      "appver": await KakaoSdk.appVer,
      "template_id": response.templateId.toString(),
      "template_args": jsonEncode(response.templateArgs),
      "template_json": jsonEncode(response.templateMsg),
      "extras": jsonEncode(await _extras(serverCallbackArgs))
    };
    var uri = Uri(scheme: "kakaolink", host: "send", queryParameters: params);
    return Uri.parse(uri.toString().replaceAll('+', '%20'));
  }

  Future<Map<String, String?>> _extras(
      [Map<String, String>? serverCallbackArgs]) async {
    Map<String, String?> extras = {
      "KA": await KakaoSdk.kaHeader,
      "lcba":
          serverCallbackArgs == null ? null : jsonEncode(serverCallbackArgs),
      ...(_platform.isAndroid
          ? {
              "appPkg": await KakaoSdk.packageName,
              "keyHash": await KakaoSdk.origin
            }
          : _platform.isIOS
              ? {"iosBundleId": await KakaoSdk.origin}
              : {}),
    };
    extras.removeWhere((k, v) => v == null);
    return extras;
  }

  Future<int> _attachmentSize(LinkResult response,
      {String? appKey, Map<String, String>? serverCallbackArgs}) async {
    final templateMsg = response.templateMsg;
    final attachment = {
      "lv": "4.0",
      "av": "4.0",
      "ak": appKey ?? KakaoSdk.nativeKey,
      "P": templateMsg["P"],
      "C": templateMsg["C"],
      "template_id": response.templateId,
      "template_args": response.templateArgs,
      "extras": jsonEncode(await _extras(serverCallbackArgs))
    };
    return utf8.encode(jsonEncode(attachment)).length;
  }
}
