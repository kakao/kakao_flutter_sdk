import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kakao_flutter_sdk_link/src/constants.dart';
import 'package:kakao_flutter_sdk_link/src/link_api.dart';
import 'package:kakao_flutter_sdk_link/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_link/src/model/link_result.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

/// 카카오링크 웹 공유 기능을 제공하는 클라이언트
class WebSharerClient {
  LinkApi api;

  WebSharerClient(this.api);

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final WebSharerClient instance = WebSharerClient(LinkApi.instance);

  /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 웹으로 공유
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고
  Future<Uri> customTemplateUri({
    required int templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 기본 템플릿을 웹으로 공유
  Future<Uri> defaultTemplateUri({
    required DefaultTemplate template,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.defaultTemplate(template);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드
  /// 지정된 URL 을 스크랩하여 만들어진 템플릿을 웹으로 공유
  Future<Uri> scrapTemplateUri({
    required String url,
    int? templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.scrap(url,
        templateId: templateId, templateArgs: templateArgs);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 로컬 이미지를 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> uploadImage({
    required File image,
    bool secureResource = true,
  }) async {
    return await api.uploadImage(image, secureResource: secureResource);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> scrapImage({
    required String imageUrl,
    bool secureResource = true,
  }) async {
    return await api.scrapImage(imageUrl, secureResource: secureResource);
  }

  Future<Uri> _sharerWithResponse(LinkResult response,
      {Map<String, String>? serverCallbackArgs}) async {
    final params = {
      Constants.sharerAppKey: KakaoSdk.nativeKey,
      Constants.sharerKa: await KakaoSdk.kaHeader,
      Constants.validationAction: Constants.custom,
      Constants.validationParams: jsonEncode({
        Constants.templateId: response.templateId,
        Constants.templateArgs: response.templateArgs,
        Constants.linkVersion: Constants.linkVersion_40
      }),
      Constants.lcba:
          serverCallbackArgs == null ? null : jsonEncode(serverCallbackArgs)
    };

    params.removeWhere((k, v) => v == null);
    return Uri.https(KakaoSdk.hosts.sharer, Constants.sharerPath, params);
  }
}
