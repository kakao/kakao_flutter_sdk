import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_share/src/model/sharing_result.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

/// KO: 카카오톡 공유 API 클라이언트, 웹 공유 기능 제공
/// <br>
/// EN: Client for the Kakao Talk Sharing APIs, provides sharing features for the web
class WebSharerClient {
  /// @nodoc
  final ShareApi api;

  static final WebSharerClient instance = WebSharerClient(ShareApi.instance);

  /// @nodoc
  WebSharerClient(this.api);

  /// KO: 사용자 정의 템플릿을 카카오톡으로 공유하기 위한 URL 생성<br>
  /// [templateId]에 사용자 정의 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 키와 값 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Creates a URL to share a custom template via Kakao Talk<br>
  /// Pass the custom template ID to [templateId]<br>
  /// Pass the keys and values of the user argument to [templateArgs]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]
  Future<Uri> makeCustomUrl({
    required int templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// KO: 기본 템플릿을 카카오톡으로 공유하기 위한 URL 생성<br>
  /// [template]에 기본 템플릿 객체 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Creates a URL to share a default template via Kakao Talk<br>
  /// Pass the default template object to [template]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]
  Future<Uri> makeDefaultUrl({
    required DefaultTemplate template,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.defaultTemplate(template);
    return _sharerWithResponse(response,
        serverCallbackArgs: serverCallbackArgs);
  }

  /// KO: 스크랩 정보로 구성된 메시지 템플릿을 카카오톡으로 공유하기 위한 URL 생성<br>
  /// [url]에 스크랩할 URL 전달<br>
  /// [templateId]에 사용자 정의 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 키와 값 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Creates a URL to share a scrape message via Kakao Talk<br>
  /// Pass the URL to scrape [url]<br>
  /// Pass the custom template ID to [templateId]<br>
  /// Pass the keys and values of the user argument to [templateArgs]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]
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

  /// KO: 이미지 업로드<br>
  /// [image]에 이미지 파일 전달<br>
  /// [secureResource]로 이미지 URL을 HTTPS로 설정<br>
  /// <br>
  /// EN: Upload image<br>
  /// Pass the image file to [image]<br>
  /// Set whether to use HTTPS for the image URL with [secureResource]
  Future<ImageUploadResult> uploadImage({
    File? image,
    Uint8List? byteData,
    bool secureResource = true,
  }) async {
    if (image == null && byteData == null) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'Either parameter image or byteData must not be null.',
      );
    }
    return await api.uploadImage(image, byteData,
        secureResource: secureResource);
  }

  /// KO: 이미지 스크랩<br>
  /// [imageUrl]에 이미지 URL 전달<br>
  /// [secureResource]로 이미지 URL을 HTTPS로 설정<br>
  /// <br>
  /// EN: Scrape image<br>
  /// Pass the image URL to [imageUrl]<br>
  /// Set whether to use HTTPS for the image URL with [secureResource]
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
