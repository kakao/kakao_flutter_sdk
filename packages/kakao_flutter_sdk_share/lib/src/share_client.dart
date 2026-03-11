import 'dart:convert';
import 'dart:typed_data';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

import 'constants.dart';
import 'model/image_upload_result.dart';
import 'model/sharing_result.dart';
import 'share_api.dart';
import 'share_platform.dart';

/// KO: 카카오톡 공유 API 클라이언트
/// <br>
/// EN: Client for the Kakao Talk Sharing APIs

class ShareClient {
  /// @nodoc
  ShareClient({ShareApi? api, SharePlatform? platform})
    : _api = api ?? ShareApi(KakaoHttpClientFactory.appKeyApi),
      _platform = platform ?? SharePlatform.instance;

  final ShareApi _api;
  final SharePlatform _platform;

  /// @nodoc
  static final ShareClient instance = ShareClient();

  /// KO: 카카오톡 공유 가능 여부 조회
  /// <br>
  /// EN: Checks whether the Kakao Talk Sharing is available
  Future<bool> isKakaoTalkSharingAvailable() {
    return _platform.isKakaoTalkSharingAvailable().then((available) {
      SdkLog.i(
        '[ShareClient.isKakaoTalkSharingAvailable] completed | available=$available',
      );
      return available;
    });
  }

  /// KO: 사용자 정의 템플릿으로 메시지 발송<br>
  /// [templateId]에 사용자 정의 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 키와 값 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Send message with custom template<br>
  /// Pass the custom template ID to [templateId]<br>
  /// Pass the keys and values of the user argument to [templateArgs]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]<br>
  Future<void> shareCustom({
    required int templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    SdkLog.d(
      '[ShareClient.shareCustom] started | templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0} callbackArgsCount=${serverCallbackArgs?.length ?? 0}',
    );
    final response = await _api.custom(templateId, templateArgs: templateArgs);

    final url = _createUrl(response, serverCallbackArgs: serverCallbackArgs);
    SdkLog.v('[ShareClient.shareCustom] launch_url_created | url=$url');

    await _platform.launchKakaoTalk(url);
    SdkLog.i('[ShareClient.shareCustom] completed');
  }

  /// KO: 기본 템플릿으로 메시지 발송<br>
  /// [template]에 메시지 템플릿 객체 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Send message with default template<br>
  /// Pass an object of a message template to [template]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]<br>
  Future<void> shareDefault({
    required DefaultTemplate template,
    Map<String, String>? serverCallbackArgs,
  }) async {
    SdkLog.d(
      '[ShareClient.shareDefault] started | templateType=${template.runtimeType} callbackArgsCount=${serverCallbackArgs?.length ?? 0}',
    );
    final response = await _api.defaultTemplate(template);

    final url = _createUrl(response, serverCallbackArgs: serverCallbackArgs);
    SdkLog.v('[ShareClient.shareDefault] launch_url_created | url=$url');

    await _platform.launchKakaoTalk(url);
    SdkLog.i('[ShareClient.shareDefault] completed');
  }

  /// KO: 스크랩 메시지 발송<br>
  /// [url]에 스크랩할 URL 전달<br>
  /// [templateId]에 사용자 정의 템플릿 ID 전달<br>
  /// [templateArgs]에 사용자 인자 키와 값 전달<br>
  /// [serverCallbackArgs]에 카카오톡 공유 전송 성공 알림에 포함할 키와 값 전달<br>
  /// <br>
  /// EN: Send scrape message<br>
  /// Pass the URL to scrape [url]<br>
  /// Pass the custom template ID to [templateId]<br>
  /// Pass the keys and values of the user argument to [templateArgs]<br>
  /// Pass the keys and values for the Kakao Talk Sharing success callback to [serverCallbackArgs]<br>
  Future<void> shareScrap({
    required String url,
    int? templateId,
    Map<String, String>? templateArgs,
    Map<String, String>? serverCallbackArgs,
  }) async {
    SdkLog.d(
      '[ShareClient.shareScrap] started | url=$url templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0} callbackArgsCount=${serverCallbackArgs?.length ?? 0}',
    );
    final response = await _api.scrap(
      url,
      templateId: templateId,
      templateArgs: templateArgs,
    );

    final appUrl = _createUrl(response, serverCallbackArgs: serverCallbackArgs);
    SdkLog.v('[ShareClient.shareScrap] launch_url_created | url=$appUrl');

    await _platform.launchKakaoTalk(appUrl);
    SdkLog.i('[ShareClient.shareScrap] completed');
  }

  /// KO: 이미지 업로드<br>
  /// [imagePath]에 이미지 파일 경로 전달<br>
  /// [secureResource]로 이미지 URL을 HTTPS로 설정<br>
  /// <br>
  /// EN: Upload image<br>
  /// Pass image file path to [imagePath]<br>
  /// Set whether to use HTTPS for the image URL with [secureResource]
  Future<ImageUploadResult> uploadImage({
    String? imagePath,
    Uint8List? byteData,
    bool secureResource = true,
  }) {
    if (imagePath == null && byteData == null) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'Either image file or byte data must be provided.',
      );
    }

    SdkLog.d(
      '[ShareClient.uploadImage] started | hasImagePath=${imagePath != null} hasByteData=${byteData != null} secureResource=$secureResource',
    );
    return _api.uploadImage(imagePath, byteData, secureResource);
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
  }) {
    SdkLog.d(
      '[ShareClient.scrapImage] started | imageUrl=$imageUrl secureResource=$secureResource',
    );
    return _api.scrapImage(imageUrl, secureResource);
  }

  String _createUrl(
    SharingResult response, {
    Map<String, String>? serverCallbackArgs,
  }) {
    final attachmentSize = _calculateAttachmentSize(
      response,
      serverCallbackArgs,
    );

    if (attachmentSize > 10 * 1024) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'Exceeded message template v2 size limit (${attachmentSize / 1024}kb > 10kb).',
      );
    }

    SdkLog.v(
      '[ShareClient.createUrl] validated | attachmentSizeBytes=$attachmentSize',
    );
    final appScheme = KakaoSdk.platform.talkSharingScheme;
    final queryParameter = _createQueryParams(response, serverCallbackArgs);

    return '$appScheme://send?$queryParameter';
  }

  int _calculateAttachmentSize(
    SharingResult response,
    Map<String, String>? serverCallbackArgs,
  ) {
    final templateMsg = response.templateMsg;
    final attachment = <String, Object>{
      Constants.lv: Constants.linkVersion_40,
      Constants.av: Constants.linkVersion_40,
      Constants.ak: KakaoSdk.appKey,
      Constants.P: templateMsg[Constants.P],
      Constants.C: templateMsg[Constants.C],
      Constants.templateId: response.templateId,
      Constants.templateArgs: ?response.templateArgs,
      Constants.extras: jsonEncode(_createExtras(serverCallbackArgs)),
    };
    return utf8.encode(jsonEncode(attachment)).length;
  }

  String _createQueryParams(
    SharingResult response,
    Map<String, String>? serverCallbackArgs,
  ) {
    final String? templateArgs = response.templateArgs?.toEncodedJson();
    final String templateMsg = response.templateMsg.toEncodedJson();
    final extras = _createExtras(serverCallbackArgs).toEncodedJson();

    return <String, Object>{
      Constants.linkVer: Constants.linkVersion_40,
      Constants.appKey: KakaoSdk.appKey,
      Constants.appVer: KakaoSdk.platformInfo.appVer,
      Constants.templateId: response.templateId,
      Constants.templateArgs: ?templateArgs,
      Constants.templateJson: templateMsg,
      Constants.extras: extras,
      Constants.list: ?response.schemeParams?[Constants.list],
      Constants.limit: ?response.schemeParams?[Constants.limit],
    }.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
  }

  Map<String, String> _createExtras(Map<String, String>? serverCallbackArgs) {
    final platformExtras = _platform.platformExtras();

    return <String, String>{
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
      Constants.lcba: ?serverCallbackArgs?.toJson(),
      ...platformExtras,
    };
  }
}
