import 'dart:convert';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:web/web.dart';

import '../constants.dart';
import '../model/follow_channel_result.dart';
import '../talk_platform.dart';
import 'mobile.dart';

/// @nodoc
class TalkPlatformImpl extends TalkPlatform {
  @override
  Future<FollowChannelResult> followChannel(String channelPublicId) async {
    _checkSupportBrowser();

    final transId = generateRandomString(60);

    final params = <String, String>{
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
      Constants.appKey: KakaoSdk.appKey,
      Constants.channelPublicId: channelPublicId,
      Constants.transId: transId,
    };

    if (await AuthApi.instance.hasToken()) {
      final agt = await AuthApi.instance.agt();
      params[Constants.agt] = agt;
    }

    final url = Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.apps,
      path: Constants.followChannelPath,
      query: params.toQuery(),
    ).toString();

    SdkLog.v('[TalkPlatformImpl.followChannel] request_url_created | url=$url');

    final result = await AuthPlatform.instance.handleAppsUrl(
      url,
      transId: transId,
      popupTitle: 'follow_channel',
    );

    SdkLog.i('[TalkPlatformImpl.followChannel] completed | result=$result');
    final resultJson = jsonDecode(result);

    if (resultJson.containsKey('error_code')) {
      throw KakaoAppsException.fromJson(resultJson);
    }
    return FollowChannelResult.fromJson(resultJson);
  }

  @override
  Future<void> addChannel(String channelPublicId) {
    if (!isMobileWeb()) {
      final url = Uri(
        scheme: 'https',
        host: KakaoSdk.hosts.pf,
        path: '$channelPublicId/friend',
        query: channelBaseParams().toQuery(),
      ).toString();

      return Future.sync(() => window.open(url, 'channel_add_social_plugin'));
    }

    final path = 'home/$channelPublicId/add';

    final scheme = KakaoSdk.platform.talkChannelScheme;
    final url = isAndroidWeb()
        ? androidChannelIntent(scheme, channelPublicId, path)
        : iosChannelScheme(scheme, channelPublicId, path);

    return Future.sync(() => window.location.href = url);
  }

  @override
  Future<void> chatChannel(String channelPublicId) {
    if (!isMobileWeb()) {
      final url = Uri(
        scheme: 'https',
        host: KakaoSdk.hosts.pf,
        path: '$channelPublicId/chat',
        query: channelBaseParams().toQuery(),
      ).toString();

      return Future.sync(() => window.open(url, 'channel_chat_social_plugin'));
    }

    final path = 'talk/chat/$channelPublicId';
    final extra = <String, String>{'referer': window.location.href};
    final extraParam = <String, String>{'extra': extra.toJson()};

    final scheme = KakaoSdk.platform.talkChannelScheme;
    final url = isAndroidWeb()
        ? androidChannelIntent(
            scheme,
            channelPublicId,
            path,
            queryParameters: extraParam.toQuery(),
          )
        : iosChannelScheme(
            scheme,
            channelPublicId,
            path,
            queryParameters: extraParam.toQuery(),
          );

    return Future.sync(() => window.location.href = url);
  }

  void _checkSupportBrowser() {
    final userAgent = window.navigator.userAgent;
    final currentBrowser = BrowserDetector.detect(userAgent);

    if ({Browser.facebook, Browser.instagram}.contains(currentBrowser)) {
      throw KakaoAppsException(
        AppsErrorCause.unsupported,
        'unsupported environment.',
      );
    }
  }
}
