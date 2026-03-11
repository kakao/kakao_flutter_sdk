import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'constants.dart';
import 'model/follow_channel_result.dart';
import 'platform/talk_platform_stub.dart'
    if (dart.library.io) 'platform/talk_platform_native.dart'
    if (dart.library.html) 'web/talk_platform_web.dart';

/// @nodoc
abstract class TalkPlatform {
  static final TalkPlatform instance = TalkPlatformImpl();

  Future<FollowChannelResult> followChannel(String channelPublicId);

  Future<void> addChannel(String channelPublicId);

  Future<void> chatChannel(String channelPublicId);

  Map<String, String> channelBaseParams() {
    return <String, String>{
      Constants.appKey: KakaoSdk.appKey,
      Constants.kakaoAgent: KakaoSdk.platformInfo.kaHeader,
      Constants.apiVersion: Constants.apiVersion_10,
    };
  }
}
