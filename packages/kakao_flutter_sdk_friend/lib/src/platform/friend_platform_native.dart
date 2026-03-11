import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../friend_platform.dart';
import '../model/picker_friend_request_params.dart';
import '../model/selected_user.dart';
import '../picker_web_view.dart';

/// @nodoc
class FriendPlatformImpl extends FriendPlatform {
  @override
  Future<SelectedUsers> selectFriend(
    BuildContext context,
    PickerFriendRequestParams params,
    bool enableMulti,
  ) async {
    final Map<String, String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PickerWebView(params: params, enableMulti: enableMulti),
      ),
    );

    if (result == null) {
      throw KakaoClientException(ClientErrorCause.cancelled, 'User Cancelled');
    }

    if (result.containsKey('selected')) {
      return SelectedUsers.fromJson(jsonDecode(result['selected']!));
    }

    throw KakaoApiException.fromJson(jsonDecode(result['error']!));
  }
}
