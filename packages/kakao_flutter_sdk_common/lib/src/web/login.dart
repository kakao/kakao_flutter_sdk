import 'dart:convert';

import 'package:kakao_flutter_sdk_common/src/constants.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';

String androidLoginIntent(
    String kaHeader, String userAgent, Map<String, dynamic> arguments) {
  Map<String, dynamic> extras = {
    'channel_public_id': arguments['channel_public_ids'],
    'service_terms': arguments['service_terms'],
    'approval_type': arguments['approval_type'],
    'prompt': arguments['prompt'],
    'state': arguments['state'],
  };
  extras.removeWhere((k, v) => v == null);

  var params = {
    'client_id': KakaoSdk.appKey,
    'approval_type': arguments['approval_type'],
    'scope': arguments['scope'],
    'auth_tran_id': arguments['state_token'],
    'channel_public_id': arguments['channel_public_id'],
    'prompt': arguments['prompt'],
    'login_hint': arguments['login_hint'],
    'nonce': arguments['nonce'],
    'settle_id': arguments['settle_id'],
    'redirect_uri': arguments['redirect_uri'],
    'response_type': 'code',
    'ka': kaHeader,
    'is_popup': 'true',
    'extra.channel_public_id': arguments['channel_public_ids'],
    'extra.service_terms': arguments['service_terms'],
  };
  params.removeWhere((k, v) => v == null);

  String intent = [
    'intent:#Intent',
    'action=com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY',
    'launchFlags=0x08880000',
    'S.com.kakao.sdk.talk.appKey=${KakaoSdk.appKey}',
    'S.com.kakao.sdk.talk.redirectUri=${arguments['redirect_uri']}',
    'S.com.kakao.sdk.talk.state=${arguments['state_token']}',
    'S.com.kakao.sdk.talk.kaHeader=$kaHeader',
    'S.com.kakao.sdk.talk.extraparams=${Uri.encodeComponent(jsonEncode(params))}',
    'S.browser_fallback_url=${Uri.encodeComponent(_redirectLoginThroughWeb(kaHeader, Map.castFrom(arguments)))}',
    'end;',
  ].join(';');
  return intent;
}

String iosLoginUniversalLink(String kaHeader, Map<String, dynamic> arguments) {
  final bool isPopup = arguments[CommonConstants.isPopup];
  String fallbackUrl =
      _redirectLoginThroughWeb(kaHeader, Map.castFrom(arguments));

  String iosLoginScheme = isPopup
      ? _iosPopupLoginScheme(kaHeader, arguments)
      : _iosRedirectLoginScheme(kaHeader, arguments);

  if (isPopup) {
    return '${KakaoSdk.platforms.web.iosLoginUniversalLink}${Uri.encodeComponent(iosLoginScheme)}&web=${Uri.encodeComponent(fallbackUrl)}';
  } else {
    return '${KakaoSdk.platforms.web.iosLoginUniversalLink}${Uri.encodeComponent("${KakaoSdk.platforms.web.iosInAppLoginScheme}?url=${Uri.encodeComponent(iosLoginScheme)}")}&web=${Uri.encodeComponent(iosLoginScheme)}';
  }
}

String _iosPopupLoginScheme(String kaHeader, Map<String, dynamic> arguments) {
  var params = {
    'client_id': KakaoSdk.appKey,
    'redirect_uri': arguments['redirect_uri'],
    'response_type': 'code',
    'is_popup': 'true',
    'params': jsonEncode(_makeAuthParams(arguments)),
  };
  params.removeWhere((k, v) => v == null);

  return Uri.parse(KakaoSdk.platforms.web.talkLoginScheme)
      .replace(queryParameters: params)
      .toString();
}

String _iosRedirectLoginScheme(
    String kaHeader, Map<String, dynamic> arguments) {
  var authParams = _makeAuthParams(arguments);

  var easyLoginAuthParams = {
    ...authParams,
    'is_popup': 'true',
    'ka': kaHeader,
  };
  return Uri.parse(
          '${CommonConstants.scheme}://${KakaoSdk.hosts.kauth}/oauth/authorize')
      .replace(queryParameters: easyLoginAuthParams)
      .toString();
}

String _redirectLoginThroughWeb(
    String kaHeader, Map<String, dynamic> arguments) {
  Map<String, dynamic> params = {
    ..._makeAuthParams(arguments),
    'ka': kaHeader,
    'is_popup': 'false',
  };
  return Uri.parse(
          '${CommonConstants.scheme}://${KakaoSdk.hosts.kauth}/oauth/authorize')
      .replace(queryParameters: params)
      .toString();
}

Map<String, dynamic> _makeAuthParams(Map<String, dynamic> arguments) {
  var authParams = {
    'client_id': KakaoSdk.appKey,
    'approval_type': arguments['approval_type'],
    'scope': arguments['scope'],
    'state': arguments['state_token'],
    'channel_public_id': arguments['channel_public_id'],
    'prompt': arguments['prompt'],
    // 'device_type': arguments['device_type'],
    'login_hint': arguments['login_hint'],
    'nonce': arguments['nonce'],
    'settle_id': arguments['settle_id'],
    'auth_tran_id': arguments['state_token'],
    'extra.plus_friend_public_id': arguments['plus_friend_public_id'],
    'extra.service_terms': arguments['service_terms'],
    'redirect_uri': arguments['redirect_uri'],
    'response_type': 'code',
  };
  authParams.removeWhere((k, v) => v == null);
  return authParams;
}
