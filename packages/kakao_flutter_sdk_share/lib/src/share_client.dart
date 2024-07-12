import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_share/src/model/sharing_result.dart';
import 'package:kakao_flutter_sdk_share/src/share_api.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:platform/platform.dart';

/// KO: KO: 카카오톡 공유 API 클라이언트
/// <br>
/// EN: Client for the Kakao Talk Sharing APIs
class ShareClient {
  /// @nodoc
  final ShareApi api;
  final Platform _platform;

  static const MethodChannel _channel =
      MethodChannel(CommonConstants.methodChannel);

  static final ShareClient instance = ShareClient(ShareApi.instance);

  /// @nodoc
  ShareClient(this.api, {Platform? platform})
      : _platform = platform ?? const LocalPlatform();

  /// KO: 카카오톡 공유 가능 여부 확인
  /// <br>
  /// EN: Checks whether the Kakao Talk Sharing is available
  Future<bool> isKakaoTalkSharingAvailable() async {
    var arguments = {};
    if (kIsWeb) {
    } else if (_platform.isIOS) {
      arguments.addAll({
        'talkSharingScheme':
            '${KakaoSdk.platforms.ios.talkSharingScheme}://send'
      });
    }
    return await _channel.invokeMethod(
            CommonConstants.isKakaoTalkSharingAvailable, arguments) ??
        false;
  }

  /// KO: 사용자 정의 템플릿으로 메시지 보내기<br>
  /// [templateId]에 사용자 정의 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 키와 값 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Send message with custom template<br>
  /// Pass the custom template ID to [templateId]<br>
  /// Pass the keys and values of the user argument to [templateArgs]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]
  Future<Uri> shareCustom({
    required int templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.custom(templateId, templateArgs: templateArgs);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// KO: 기본 템플릿으로 메시지 보내기<br>
  /// [template]에 메시지 템플릿 객체 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Send message with default template<br>
  /// Pass an object of a message template to [template]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]
  Future<Uri> shareDefault({
    required DefaultTemplate template,
    Map<String, String>? serverCallbackArgs,
  }) async {
    final response = await api.defaultTemplate(template);
    return _talkWithResponse(response, serverCallbackArgs: serverCallbackArgs);
  }

  /// KO: 스크랩 메시지 보내기<br>
  /// [url]에 스크랩할 URL 전달<br>
  /// [templateId]에 사용자 정의 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 키와 값 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Send scrape message<br>
  /// Pass the URL to scrape [url]<br>
  /// Pass the custom template ID to [templateId]<br>
  /// Pass the keys and values of the user argument to [templateArgs]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]
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

  /// KO: 이미지 업로드하기<br>
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

  /// KO: 이미지 스크랩하기<br>
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

  /// KO: 카카오톡 공유 실행 URL로 카카오톡 실행
  /// <br>
  /// EN: Launches Kakao Talk with the URL to execute the Kakao Talk Sharing
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
        ClientErrorCause.badParameter,
        "Exceeded message template v2 size limit (${attachmentSize / 1024}kb > 10kb).",
      );
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

    String scheme;
    if (kIsWeb) {
      scheme = KakaoSdk.platforms.web.talkSharingScheme;
    } else if (_platform.isAndroid) {
      scheme = KakaoSdk.platforms.android.talkSharingScheme;
    } else {
      scheme = KakaoSdk.platforms.ios.talkSharingScheme;
    }

    var uri = Uri(
        scheme: scheme, host: Constants.linkAuthority, queryParameters: params);
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
