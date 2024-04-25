import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_friend/src/default_values.dart';
import 'package:kakao_flutter_sdk_friend/src/model/picker_friend_request_params.dart';
import 'package:kakao_flutter_sdk_friend/src/model/selected_user.dart';
import 'package:kakao_flutter_sdk_friend/src/picker_web_view.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

const MethodChannel _channel = MethodChannel(CommonConstants.methodChannel);

/// KO: 피커 API 클래스
/// <br>
/// EN: Class for the picker APIs
class PickerApi {
  static final PickerApi instance = PickerApi();

  /// @nodoc
  PickerApi();

  /// KO: 싱글 피커 요청
  /// <br>
  /// EN: Requests a single picker
  Future selectFriend({
    required PickerFriendRequestParams params,
    BuildContext? context,
  }) async {
    if (await TokenManagerProvider.instance.manager.getToken() == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'You must log in before using FriendPicker.',
      );
    }

    if (params.minPickableCount != DefaultValues.minPickableCount) {
      params.minPickableCount = DefaultValues.minPickableCount;
    }

    if (kIsWeb) {
      try {
        return await _invokeWebPicker(params, 'single');
      } catch (e) {
        rethrow;
      }
    }

    if (context == null) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'FriendPicker requires context.',
      );
    }

    return await _navigateToWebView(
        context: context, params: params, isSingle: true);
  }

  /// KO: 멀티 피커 요청
  /// <br>
  /// EN: Requests a multi-picker
  Future selectFriends({
    required PickerFriendRequestParams params,
    BuildContext? context,
  }) async {
    if (await TokenManagerProvider.instance.manager.getToken() == null) {
      throw KakaoClientException(
        ClientErrorCause.tokenNotFound,
        'You must log in before using FriendPicker.',
      );
    }

    var exception = _isParameterCorrect(params);

    if (exception != null) {
      throw exception;
    }

    if (kIsWeb) {
      try {
        return await _invokeWebPicker(params, 'multiple');
      } catch (e) {
        rethrow;
      }
    }

    if (context == null) {
      throw KakaoClientException(
        ClientErrorCause.badParameter,
        'FriendPicker requires context.',
      );
    }

    return await _navigateToWebView(context: context, params: params);
  }

  KakaoClientException? _isParameterCorrect(PickerFriendRequestParams params) {
    int minPickableCount =
        params.minPickableCount ?? DefaultValues.minPickableCount;
    int maxPickableCount =
        params.maxPickableCount ?? DefaultValues.maxPickableCount;

    if (minPickableCount < 1) {
      return KakaoClientException(
        ClientErrorCause.badParameter,
        'Parameter minPickableCount must be greater than 1.',
      );
    }
    if (maxPickableCount > 100) {
      return KakaoClientException(
        ClientErrorCause.badParameter,
        'Parameter maxPickableCount must be 100 or less.',
      );
    }
    if (minPickableCount > maxPickableCount) {
      return KakaoClientException(
        ClientErrorCause.badParameter,
        'Parameter maxPickableCount must be greater than or equal to parameter minPickableCount.',
      );
    }
    return null;
  }

  Future _invokeWebPicker(
      PickerFriendRequestParams params, String pickerType) async {
    final token = await TokenManagerProvider.instance.manager.getToken()!;
    final response = await _channel.invokeMethod('requestWebPicker', {
      'app_key': KakaoSdk.appKey,
      'ka': await KakaoSdk.kaHeader,
      'picker_type': pickerType,
      'trans_id': generateRandomString(60),
      'access_token': token?.accessToken,
      'picker_params': params.toJson(),
      'request_url': 'https://${KakaoSdk.hosts.picker}',
    });
    if (params.returnUrl == null) {
      return SelectedUsers.fromJson(jsonDecode(response));
    }
  }

  Future _navigateToWebView({
    required BuildContext context,
    bool isSingle = false,
    required PickerFriendRequestParams params,
  }) async {
    if (!context.mounted) {
      throw KakaoClientException(
        ClientErrorCause.illegalState,
        "Context is not mouned",
      );
    }

    Map<String, String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PickerWebView(params: params, isSingle: isSingle)),
    );

    if (result == null) {
      throw KakaoClientException(
        ClientErrorCause.cancelled,
        'User Cancelled',
      );
    }

    if (result.containsKey('selected')) {
      return SelectedUsers.fromJson(jsonDecode(result['selected']!));
    } else if (result.containsKey('error')) {
      throw KakaoApiException.fromJson(jsonDecode(result['error']!));
    }
  }
}
