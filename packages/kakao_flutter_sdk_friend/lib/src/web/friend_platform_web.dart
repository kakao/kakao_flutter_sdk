import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:web/web.dart';

import '../constants.dart';
import '../friend_platform.dart';
import '../model/picker_friend_request_params.dart';
import '../model/selected_user.dart';

/// @nodoc
class FriendPlatformImpl extends FriendPlatform {
  static const String _popupName = 'friend_picker';
  static const String _popupFeatures =
      'location=no,resizable=no,status=no,scrollbars=no,width=460,height=608';
  static const Duration _redirectFallbackDelay = Duration(seconds: 5);

  @override
  Future<SelectedUsers> selectFriend(
    BuildContext context,
    PickerFriendRequestParams params,
    bool enableMulti,
  ) async {
    final baseUrl = 'https://${KakaoSdk.hosts.picker}';
    final pickerPath = enableMulti
        ? Constants.multiPickerPath
        : Constants.singlePickerPath;
    final pickerUrl = '$baseUrl/$pickerPath';

    final transId = generateRandomString(60);

    final iframe = _attachProxyIframe(baseUrl: baseUrl, transId: transId);

    final token =
        (await TokenManagerProvider.instance.manager.getToken())!.accessToken;
    final webPickerParams = _createWebPickerParams(token, transId, params);

    // Redirect 방식
    if (webPickerParams.containsKey('returnUrl')) {
      submitForm(pickerUrl, webPickerParams);

      // 리다이렉트로 동작할 때까지 잠시 대기. 대기가 끝나기 전에 페이지가 리다이렉트 되어야함.
      return Future.delayed(
        _redirectFallbackDelay,
        () => SelectedUsers(totalCount: 0, users: []),
      );
    }

    // Popup 방식
    final responseJson = await _openPopupAndWaitResult(
      baseUrl: baseUrl,
      pickerUrl: pickerUrl,
      webPickerParams: webPickerParams,
      cleanup: () => iframe.remove(),
    );

    return SelectedUsers.fromJson(jsonDecode(responseJson));
  }

  HTMLIFrameElement _attachProxyIframe({
    required String baseUrl,
    required String transId,
  }) {
    final iframe = createHiddenIframe(
      transId,
      '$baseUrl/proxy?transId=$transId',
    );
    document.body?.append(iframe);
    return iframe;
  }

  Future<String> _openPopupAndWaitResult({
    required String baseUrl,
    required String pickerUrl,
    required Map<String, Object> webPickerParams,
    required void Function() cleanup,
  }) async {
    final completer = Completer<String>();

    addMessageEventListener(
      BrowserDetector.detect(window.navigator.userAgent),
      baseUrl,
      completer,
      cleanup,
    );

    window.open(pickerUrl, _popupName, _popupFeatures);
    submitForm(pickerUrl, webPickerParams, popupName: _popupName);
    return completer.future;
  }

  Map<String, Object> _createWebPickerParams(
    String accessToken,
    String transId,
    PickerFriendRequestParams params,
  ) {
    final pickerParams = params.toJson()..removeWhere((k, v) => v == null);

    return <String, Object>{
      'token': accessToken,
      'appKey': KakaoSdk.appKey,
      'ka': KakaoSdk.platformInfo.kaHeader,
      'transId': transId,
      ...pickerParams,
    };
  }
}
