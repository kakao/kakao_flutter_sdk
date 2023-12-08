import 'dart:async';

import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';

String androidChannelIntent(String scheme, String channelPublicId, String path,
    {String? queryParameters}) {
  var customScheme = Uri.parse(scheme);

  final query = queryParameters == null ? '' : '?$queryParameters';
  final intent = [
    'intent://${customScheme.authority}/$path$query#Intent',
    'scheme=${customScheme.scheme}',
    'end'
  ].join(';');
  return intent;
}

String iosChannelScheme(String scheme, String channelPublicId, String path,
    {String? queryParameters}) {
  var query = queryParameters == null ? '' : '?$queryParameters';
  return '$scheme/$path$query';
}

Future<String> webChannelUrl(String path) async {
  return Uri(
          scheme: 'https',
          host: KakaoSdk.hosts.pf,
          path: path,
          queryParameters: await _channelBaseParams())
      .toString();
}

Future<Map> createFollowChannelParams(
  final String? accessToken,
  final String channelPublicId,
  final String transId,
) async {
  final params = {
    'access_token': accessToken,
    'ka': await KakaoSdk.kaHeader,
    'app_key': KakaoSdk.appKey,
    'channel_public_id': channelPublicId,
    'trans_id': transId,
  };
  params.removeWhere((k, v) => v == null);
  return params;
}

Future<Map<String, String>> _channelBaseParams() async {
  return {
    'app_key': KakaoSdk.appKey,
    'kakao_agent': await KakaoSdk.kaHeader,
    'api_ver': '1.0'
  };
}
