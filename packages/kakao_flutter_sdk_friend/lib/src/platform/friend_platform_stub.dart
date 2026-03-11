import '../friend_platform.dart';
import '../model/picker_friend_request_params.dart';
import '../model/selected_user.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// @nodoc
class FriendPlatformImpl extends FriendPlatform {
  @override
  Future<SelectedUsers> selectFriend(
    BuildContext context,
    PickerFriendRequestParams params,
    bool enableMulti,
  ) async {
    throw KakaoClientException.notSupported();
  }
}
