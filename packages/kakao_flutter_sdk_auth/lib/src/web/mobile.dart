import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import '../constants.dart';

/// @nodoc
String androidLoginIntent(
  String redirectUri,
  String stateToken,
  String? nonce,
  List<String>? channelPublicIds,
  List<String>? serviceTerms,
) {
  final kaHeader = KakaoSdk.platformInfo.kaHeader;

  final params = <String, String>{
    Constants.authTranId: stateToken,
    Constants.nonce: ?nonce,
    Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
    Constants.channelPublicId: ?channelPublicIds?.join(','),
    'extra.${Constants.serviceTerms}': ?serviceTerms?.join(','),
    Constants.isPopup: true.toString(),
  };

  final fallbackUrl = _redirectLoginThroughWeb(
    redirectUri,
    stateToken,
    nonce,
    channelPublicIds,
    serviceTerms,
  );

  final intent = [
    'intent:#Intent',
    'action=com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY',
    'launchFlags=0x08880000',
    'S.com.kakao.sdk.talk.appKey=${KakaoSdk.appKey}',
    'S.com.kakao.sdk.talk.redirectUri=$redirectUri',
    'S.com.kakao.sdk.talk.state=$stateToken',
    'S.com.kakao.sdk.talk.kaHeader=$kaHeader',
    'S.com.kakao.sdk.talk.extraparams=${params.toEncodedJson()}',
    'S.browser_fallback_url=${Uri.encodeComponent(fallbackUrl)}',
    'end;',
  ].join(';');
  return intent;
}

/// @nodoc
String iosLoginUniversalLink(
  String redirectUri,
  String stateToken,
  String? nonce,
  List<String>? channelPublicIds,
  List<String>? serviceTerms,
) {
  final iosLoginScheme = _iosRedirectLoginScheme(
    redirectUri,
    stateToken,
    nonce,
    channelPublicIds,
    serviceTerms,
  );

  return '${KakaoSdk.platform.iosLoginUniversalLink}${Uri.encodeComponent("${KakaoSdk.platform.iosInAppLoginScheme}?url=${Uri.encodeComponent(iosLoginScheme)}")}&web=${Uri.encodeComponent(iosLoginScheme)}';
}

String _redirectLoginThroughWeb(
  String redirectUri,
  String stateToken,
  String? nonce,
  List<String>? channelPublicIds,
  List<String>? serviceTerms,
) {
  final params = <String, String>{
    Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
    Constants.isPopup: false.toString(),
    ..._makeAuthParams(
      redirectUri,
      stateToken,
      nonce,
      channelPublicIds,
      serviceTerms,
    ),
  };

  return Uri(
    scheme: 'https',
    host: KakaoSdk.hosts.kauth,
    path: Constants.authorizePath,
    query: params.toQuery(),
  ).toString();
}

Map<String, String> _makeAuthParams(
  String redirectUri,
  String stateToken,
  String? nonce,
  List<String>? channelPublicIds,
  List<String>? serviceTerms,
) {
  final authParams = <String, String>{
    Constants.clientId: KakaoSdk.appKey,
    Constants.redirectUri: redirectUri,
    Constants.state: stateToken,
    Constants.nonce: ?nonce,
    Constants.channelPublicId: ?channelPublicIds?.join(' '),
    'extra.${Constants.serviceTerms}': ?serviceTerms?.join(' '),
    Constants.responseType: Constants.code,
  };
  return authParams;
}

String _iosRedirectLoginScheme(
  String redirectUri,
  String stateToken,
  String? nonce,
  List<String>? channelPublicIds,
  List<String>? serviceTerms,
) {
  final authParams = _makeAuthParams(
    redirectUri,
    stateToken,
    nonce,
    channelPublicIds,
    serviceTerms,
  );

  final easyLoginAuthParams = <String, String>{
    ...authParams,
    Constants.isPopup: true.toString(), // 톡 웹뷰를 닫기 위해 true 설정
    Constants.kaHeader: KakaoSdk.platformInfo.kaHeader,
  };

  return Uri(
    scheme: 'https',
    host: KakaoSdk.hosts.kauth,
    path: Constants.authorizePath,
    query: easyLoginAuthParams.toQuery(),
  ).toString();
}
