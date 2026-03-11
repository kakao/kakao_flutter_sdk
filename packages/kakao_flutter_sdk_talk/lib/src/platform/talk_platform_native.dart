import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../constants.dart';
import '../model/follow_channel_result.dart';
import '../talk_platform.dart';

/// @nodoc
class TalkPlatformImpl extends TalkPlatform {
  @override
  Future<FollowChannelResult> followChannel(String channelPublicId) async {
    final hasToken = await AuthApi.instance.hasToken();

    String? agt;
    if (hasToken) {
      await AuthApi.instance.refreshToken();
      agt = await AuthApi.instance.agt();
    }

    final params = <String, String>{
      Constants.appKey: KakaoSdk.appKey,
      Constants.channelPublicId: channelPublicId,
      Constants.returnUrl:
          '${KakaoSdk.customScheme}://${Constants.followChannelScheme}',
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
      Constants.agt: ?agt,
    };

    final url = Uri(
      scheme: 'https',
      host: KakaoSdk.hosts.apps,
      path: Constants.followChannelPath,
      query: params.toQuery(),
    ).toString();

    SdkLog.v('[TalkPlatformImpl.followChannel] request_url_created | url=$url');

    final result = await AuthPlatform.instance.handleAppsUrl(url);
    final resultUrl = Uri.parse(result);
    SdkLog.i(
      '[TalkPlatformImpl.followChannel] completed | resultUrl=$resultUrl',
    );

    if (resultUrl.queryParameters[Constants.status] ==
        Constants.followChannelStatusError) {
      throw KakaoAppsException.fromJson(resultUrl.queryParameters);
    }
    return FollowChannelResult.fromJson(resultUrl.queryParameters);
  }

  @override
  Future<void> addChannel(String channelPublicId) async {
    final isTalkAvailable = await CommonPlatform.instance.isKakaoTalkAvailable(
      KakaoSdk.platform.talkChannelScheme,
    );

    if (!isTalkAvailable) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'KakaoTalk is not installed on the device.',
      );
    }

    final scheme = KakaoSdk.platform.talkChannelScheme;

    await _validate(Constants.validateAdd, channelPublicId);

    final url = '$scheme/home/$channelPublicId/add';
    await CommonPlatform.instance.launchUrl(url);
  }

  @override
  Future<void> chatChannel(String channelPublicId) async {
    final isTalkAvailable = await CommonPlatform.instance.isKakaoTalkAvailable(
      KakaoSdk.platform.talkChannelScheme,
    );

    if (!isTalkAvailable) {
      throw KakaoClientException(
        ClientErrorCause.notSupported,
        'KakaoTalk is not installed on the device.',
      );
    }

    final scheme = KakaoSdk.platform.talkChannelScheme;

    await _validate(Constants.validateChat, channelPublicId);

    final url = '$scheme/talk/chat/$channelPublicId';
    await CommonPlatform.instance.launchUrl(url);
  }

  Future<void> _validate(String path, String channelPublicId) async {
    final client = KakaoHttpClientFactory.appKeyApi;
    final quotaProperties = <String, String>{
      Constants.uri: path,
      Constants.channelPublicId: channelPublicId,
    };
    final data = <String, String>{
      Constants.quotaProperties: quotaProperties.toJson(),
    }.toQuery();

    await client.post(Constants.validatePath, data: data);
  }
}
