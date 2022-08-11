import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_share/src/model/sharing_result.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

/// 카카오톡 공유를 웹으로 제공하는 클라이언트
class WebSharerClient {
  ShareApi api;

  WebSharerClient(this.api);

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final WebSharerClient instance = WebSharerClient(ShareApi.instance);

  /// 카카오디벨로퍼스에서 생성한 메시지 템플릿을 웹으로 공유
  /// 템플릿을 생성하는 방법은 [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/ko/message/message-template) 참고
  Future<Uri> makeCustomUrl({
    required int templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 기본 템플릿을 웹으로 공유
  Future<Uri> makeDefaultUrl({
    required DefaultTemplate template,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.defaultTemplate(template);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// 원격 이미지를 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 카카오 이미지 서버로 업로드
  /// 지정된 URL 을 스크랩하여 만들어진 템플릿을 웹으로 공유
  Future<Uri> makeScrapUrl({
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

  /// 로컬 이미지를 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> uploadImage({
    File? image,
    Uint8List? byteData,
    bool secureResource = true,
  }) async {
    if (image == null && byteData == null) {
      throw KakaoClientException(
          'Either parameter image or byteData must not be null.');
    }
    return await api.uploadImage(image, byteData,
        secureResource: secureResource);
  }

  /// 원격 이미지를 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> scrapImage({
    required String imageUrl,
    bool secureResource = true,
  }) async {
    return await api.scrapImage(imageUrl, secureResource: secureResource);
  }

  Future<Uri> _sharerWithResponse(SharingResult response,
      {Map<String, String>? serverCallbackArgs}) async {
    final params = {
      Constants.sharerAppKey: KakaoSdk.appKey,
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
