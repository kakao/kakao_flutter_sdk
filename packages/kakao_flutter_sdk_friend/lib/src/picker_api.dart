import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_friend/src/default_values.dart';
import 'package:kakao_flutter_sdk_friend/src/model/picker_friend_request_params.dart';
import 'package:kakao_flutter_sdk_friend/src/model/selected_user.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

const MethodChannel _channel = MethodChannel(CommonConstants.methodChannel);

class PickerApi {
  PickerApi();

  /// 간편한 API 호출을 위해 기본 제공되는 singleton 객체
  static final PickerApi instance = PickerApi();

  Future selectFriend({
    required PickerFriendRequestParams params,
    BuildContext? context,
  }) async {
    if (await TokenManagerProvider.instance.manager.getToken() == null) {
      throw KakaoClientException('You must log in before using FriendPicker.');
    }

    if (params.minPickableCount != DefaultValues.minPickableCount) {
      params.minPickableCount = DefaultValues.minPickableCount;
    }

    if (kIsWeb) {
      try {
        var response = await _channel.invokeMethod('requestWebPicker', {
          'picker_type': 'single',
          'trans_id': generateRandomString(60),
          'access_token':
              (await TokenManagerProvider.instance.manager.getToken())!
                  .accessToken,
          'picker_params': params.toJson(),
        });
        if (params.returnUrl == null) {
          return SelectedUsers.fromJson(jsonDecode(response));
        }
        return;
      } catch (e) {
        rethrow;
      }
    }

    if (context == null) {
      throw KakaoClientException('FriendPicker requires context.');
    }

    // TODO: implement native(android, ios) web picker
    return SelectedUsers(totalCount: 12345);
  }

  Future selectFriends({
    required PickerFriendRequestParams params,
    BuildContext? context,
  }) async {
    if (await TokenManagerProvider.instance.manager.getToken() == null) {
      throw KakaoClientException('You must log in before using FriendPicker.');
    }

    var exception = _isParameterCorrect(params);

    if (exception != null) {
      throw exception;
    }

    if (kIsWeb) {
      try {
        var response = await _channel.invokeMethod('requestWebPicker', {
          'picker_type': 'multiple',
          'trans_id': generateRandomString(60),
          'access_token':
              (await TokenManagerProvider.instance.manager.getToken())!
                  .accessToken,
          'picker_params': params.toJson(),
        });
        if (params.returnUrl == null) {
          return SelectedUsers.fromJson(jsonDecode(response));
        }
        return;
      } catch (e) {
        rethrow;
      }
    }

    if (context == null) {
      throw KakaoClientException('FriendPicker requires context.');
    }

    // TODO: implement native(android, ios) web picker
    return SelectedUsers(totalCount: 12345);
  }

  KakaoClientException? _isParameterCorrect(PickerFriendRequestParams params) {
    int minPickableCount =
        params.minPickableCount ?? DefaultValues.minPickableCount;
    int maxPickableCount =
        params.maxPickableCount ?? DefaultValues.maxPickableCount;

    if (minPickableCount < 1) {
      return KakaoClientException(
          'Parameter minPickableCount must be greater than 1.');
    }
    if (maxPickableCount > 100) {
      return KakaoClientException(
          'Parameter maxPickableCount must be 100 or less.');
    }
    if (minPickableCount > maxPickableCount) {
      return KakaoClientException(
          'Parameter maxPickableCount must be greater than or equal to parameter minPickableCount.');
    }
    return null;
  }
}
