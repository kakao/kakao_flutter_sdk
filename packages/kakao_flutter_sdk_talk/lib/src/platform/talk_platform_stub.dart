import '../talk_platform.dart';
import '../model/follow_channel_result.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// @nodoc
class TalkPlatformImpl extends TalkPlatform {
  @override
  Future<FollowChannelResult> followChannel(String channelPublicId) async {
    throw _notSupportedError();
  }

  @override
  Future<void> addChannel(String channelPublicId) async {
    throw _notSupportedError();
  }

  @override
  Future<void> chatChannel(String channelPublicId) async {
    throw _notSupportedError();
  }

  KakaoClientException _notSupportedError() {
    return KakaoClientException.notSupported();
  }
}
