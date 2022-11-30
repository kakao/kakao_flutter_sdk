import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_share/src/model/sharing_result.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:platform/platform.dart';

/// 카카오톡 공유 호출을 담당하는 클라이언트.
class ShareClient {
  ShareClient(this.api, {Platform? platform})
      : _platform = platform ?? const LocalPlatform();
  ShareApi api;
  final Platform _platform;

  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final ShareClient instance = ShareClient(ShareApi.instance);

  /// 카카오톡 실행을 통한 공유 가능 여부 확인
  Future<bool> isKakaoTalkSharingAvailable() async {
    return await _channel
            .invokeMethod(CommonConstants.isKakaoTalkSharingAvailable) ??
        false;
  }

  /// 카카오디벨로퍼스에서 생성한 메시지 템플릿으로 카카오톡 공유 URI 생성, [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/message/message-template) 참고
  Future<Uri> shareCustom({
    required int templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// 기본 템플릿으로 카카오톡 공유 URI 생성, [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/message/message-template) 참고
  Future<Uri> shareDefault({
    required DefaultTemplate template,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.defaultTemplate(template);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// 특정 URL의 웹 페이지 정보를 바탕으로 카카오톡 공유 URI 생성, [메시지 템플릿 가이드](https://developers.kakao.com/docs/latest/message/message-template) 참고
  Future<Uri> shareScrap({
    required String url,
    int? templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.scrap(url,
        templateId: templateId, templateArgs: templateArgs);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
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

  /// 원격 이미지를 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 카카오 이미지 서버에 스크랩
  Future<ImageUploadResult> scrapImage({
    required String imageUrl,
    bool secureResource = true,
  }) async {
    return await api.scrapImage(imageUrl, secureResource: secureResource);
  }

  Future<void> launchKakaoTalk(Uri uri) {
    return _channel.invokeMethod(
        CommonConstants.launchKakaoTalk, {Constants.uri: uri.toString()});
  }

  Future<Uri> _talkWithResponse(SharingResult response,
      {String? appKey, Map<String, String>? serverCallbackArgs}) async {
    final attachmentSize = await _attachmentSize(response,
        appKey: appKey, serverCallbackArgs: serverCallbackArgs);
    if (attachmentSize > 10 * 1024) {
      throw KakaoClientException(
          "Exceeded message template v2 size limit (${attachmentSize / 1024}kb > 10kb).");
    }
    Map<String, String> params = {
      Constants.linkVer: Constants.linkVersion_40,
      Constants.appKey: appKey ?? KakaoSdk.appKey,
      Constants.appVer: await KakaoSdk.appVer,
      Constants.templateId: response.templateId.toString(),
      Constants.templateArgs: jsonEncode(response.templateArgs),
      Constants.templateJson: jsonEncode(response.templateMsg),
      Constants.extras: jsonEncode(await _extras(serverCallbackArgs))
    };
    var uri = Uri(
        scheme: Constants.linkScheme,
        host: Constants.linkAuthority,
        queryParameters: params);
    var linkUri = Uri.parse(uri.toString().replaceAll('+', '%20'));
    SdkLog.i(linkUri);
    return linkUri;
  }

  Future<Map<String, String?>> _extras(
      [Map<String, String>? serverCallbackArgs]) async {
    var platformInfo = (kIsWeb
        ? {}
        : _platform.isAndroid
            ? {
                Constants.appPkg: await KakaoSdk.packageName,
                Constants.keyHash: await KakaoSdk.origin
              }
            : _platform.isIOS
                ? {Constants.iosBundleId: await KakaoSdk.origin}
                : {});
    Map<String, String?> extras = {
      Constants.ka: await KakaoSdk.kaHeader,
      Constants.lcba:
          serverCallbackArgs == null ? null : jsonEncode(serverCallbackArgs),
      ...platformInfo,
    };
    extras.removeWhere((k, v) => v == null);
    return extras;
  }

  Future<int> _attachmentSize(SharingResult response,
      {String? appKey, Map<String, String>? serverCallbackArgs}) async {
    final templateMsg = response.templateMsg;
    final attachment = {
      Constants.lv: Constants.linkVersion_40,
      Constants.av: Constants.linkVersion_40,
      Constants.ak: appKey ?? KakaoSdk.appKey,
      Constants.P: templateMsg[Constants.P],
      Constants.C: templateMsg[Constants.C],
      Constants.templateId: response.templateId,
      Constants.templateArgs: response.templateArgs,
      Constants.extras: jsonEncode(await _extras(serverCallbackArgs))
    };
    return utf8.encode(jsonEncode(attachment)).length;
  }
}
