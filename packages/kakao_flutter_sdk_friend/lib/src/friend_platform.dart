import 'package:flutter/widgets.dart';

import 'model/picker_friend_request_params.dart';
import 'model/selected_user.dart';
import 'platform/friend_platform_stub.dart'
    if (dart.library.io) 'platform/friend_platform_native.dart'
    if (dart.library.html) 'web/friend_platform_web.dart';

/// @nodoc
abstract class FriendPlatform {
  static final FriendPlatform instance = FriendPlatformImpl();

  Future<SelectedUsers> selectFriend(
    BuildContext context,
    PickerFriendRequestParams params,
    bool enableMulti,
  );
}
