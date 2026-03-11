import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'friend_platform.dart';
import 'model/picker_friend_request_params.dart';
import 'model/selected_user.dart';

/// KO: 피커 API 클래스
/// <br>
/// EN: Class for the picker APIs
class PickerApi {
  /// @nodoc
  PickerApi({FriendPlatform? platform})
    : _platform = platform ?? FriendPlatform.instance;

  final FriendPlatform _platform;

  /// @nodoc
  static final PickerApi instance = PickerApi();

  /// KO: 친구 피커
  /// <br>
  /// EN: Friends picker
  Future<SelectedUsers> selectFriend({
    required BuildContext context,
    required PickerFriendRequestParams params,
    bool enableMulti = true,
  }) async {
    SdkLog.d(
      '[PickerApi.selectFriend] started | enableMulti=$enableMulti minPickableCount=${params.minPickableCount} maxPickableCount=${params.maxPickableCount}',
    );
    final token = await TokenManagerProvider.instance.manager.getToken();
    if (token == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'You must log in before using FriendPicker.',
      );
    }

    final verifiedParams = _validateAndAdjustParams(params, enableMulti);

    if (!context.mounted) {
      throw KakaoClientException(
        ClientErrorCause.illegalState,
        'Context is not mounted.',
      );
    }

    final result = await _platform.selectFriend(
      context,
      verifiedParams,
      enableMulti,
    );
    SdkLog.i(
      '[PickerApi.selectFriend] completed | selectedUserCount=${result.users?.length ?? 0}',
    );
    return result;
  }

  PickerFriendRequestParams _validateAndAdjustParams(
    PickerFriendRequestParams params,
    bool enableMulti,
  ) {
    if (!enableMulti) {
      SdkLog.d('[PickerApi.validateAndAdjustParams] adjusted | mode=single');
      return params.clone(maxPickableCount: 1, minPickableCount: 1);
    }

    final minCount = params.minPickableCount ?? DefaultValues.minPickableCount;
    final maxCount = params.maxPickableCount ?? DefaultValues.maxPickableCount;

    _validatePickableCount(minCount, maxCount);

    SdkLog.v(
      '[PickerApi.validateAndAdjustParams] validated | minPickableCount=$minCount maxPickableCount=$maxCount',
    );
    return params.clone(maxPickableCount: maxCount, minPickableCount: minCount);
  }

  void _validatePickableCount(int minCount, int maxCount) {
    if (minCount < 1) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'minPickableCount must be greater than or equal to 1.',
      );
    }

    if (maxCount > 100) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'maxPickableCount must be 100 or less.',
      );
    }

    if (minCount > maxCount) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'maxPickableCount must be greater than or equal to minPickableCount.',
      );
    }
  }
}
