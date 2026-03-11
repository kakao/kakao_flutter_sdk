import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

import 'constants.dart';
import 'model/sharing_result.dart';
import 'share_api.dart';
import 'share_platform.dart';

/// KO: 카카오톡 공유 API 클라이언트, 웹 공유 기능 제공
/// <br>
/// EN: Client for the Kakao Talk Sharing APIs, provides sharing features for the web
class WebSharerClient {
  /// @nodoc
  WebSharerClient({ShareApi? api, SharePlatform? platform})
    : _api = api ?? ShareApi(KakaoHttpClientFactory.appKeyApi);

  /// @nodoc
  final ShareApi _api;

  /// @nodoc
  static final WebSharerClient instance = WebSharerClient();

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
    SdkLog.d(
      '[WebSharerClient.makeCustomUrl] started | templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0} callbackArgsCount=${serverCallbackArgs?.length ?? 0}',
    );
    final response = await _api.custom(templateId, templateArgs: templateArgs);
    final url = _createUrl(response, serverCallbackArgs);
    SdkLog.i('[WebSharerClient.makeCustomUrl] completed | url=$url');
    return url;
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
    SdkLog.d(
      '[WebSharerClient.makeDefaultUrl] started | templateType=${template.runtimeType} callbackArgsCount=${serverCallbackArgs?.length ?? 0}',
    );
    final response = await _api.defaultTemplate(template);
    final url = _createUrl(response, serverCallbackArgs);
    SdkLog.i('[WebSharerClient.makeDefaultUrl] completed | url=$url');
    return url;
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
    SdkLog.d(
      '[WebSharerClient.makeScrapUrl] started | url=$url templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0} callbackArgsCount=${serverCallbackArgs?.length ?? 0}',
    );
    final response = await _api.scrap(
      url,
      templateId: templateId,
      templateArgs: templateArgs,
    );

    final sharerUrl = _createUrl(response, serverCallbackArgs);
    SdkLog.i('[WebSharerClient.makeScrapUrl] completed | url=$sharerUrl');
    return sharerUrl;
  }

  Uri _createUrl(
    SharingResult response,
    Map<String, String>? serverCallbackArgs,
  ) {
    final params = <String, Object>{
      Constants.sharerAppKey: KakaoSdk.appKey,
      Constants.sharerKa: KakaoSdk.platformInfo.kaHeader,
      Constants.validationAction: Constants.custom,
      Constants.validationParams: _createValidationParams(response),
      Constants.lcba: ?serverCallbackArgs,
    };

    return Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.sharer,
      path: Constants.sharerPath,
      query: params.toQuery(),
    );
  }

  String _createValidationParams(SharingResult response) {
    return <String, Object>{
      Constants.templateId: response.templateId,
      Constants.templateArgs: ?response.templateArgs,
      Constants.linkVersion: Constants.linkVersion_40,
    }.toJson();
  }
}
