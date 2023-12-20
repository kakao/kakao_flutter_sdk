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

String createFollowChannelUrl(final Map params) {
  const path = '/talk/channel/follow';

  var url = 'https://${KakaoSdk.hosts.apps}$path?';
  params.forEach((k, v) => url = '$url$k=$v&');

  url.substring(0, url.length - 1);
  return url;
}

Future<Map<String, String>> _channelBaseParams() async {
  return {
    'app_key': KakaoSdk.appKey,
    'kakao_agent': await KakaoSdk.kaHeader,
    'api_ver': '1.0'
  };
}
