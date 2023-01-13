import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_common/src/constants.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';
import 'package:platform/platform.dart';

const MethodChannel _methodChannel =
    MethodChannel(CommonConstants.methodChannel);
const _platform = LocalPlatform();

/// 종료된 앱이 카카오 스킴 호출로 실행될 때 URL 전달
Future<String?> receiveKakaoScheme() async {
  if (kIsWeb) {
    return null;
  }
  return await _methodChannel.invokeMethod(CommonConstants.receiveKakaoScheme);
}

/// 실행 중인 앱이 카카오 스킴 호출로 실행될 때 URL 전달
Stream<String?> get kakaoSchemeStream {
  if (kIsWeb) {
    return Stream.value(null);
  }

  return const EventChannel(CommonConstants.eventChannel)
      .receiveBroadcastStream()
      .map<String?>((link) => link as String?);
}

/// 플랫폼별 기본 브라우저로 URL 실행
/// URL을 팝업으로 열고싶을 때 [popupOpen] 사용. 웹에서만 사용 가능
Future<String> launchBrowserTab(Uri uri,
    {String? redirectUri, bool popupOpen = false}) async {
  if (uri.scheme != CommonConstants.http &&
      uri.scheme != CommonConstants.scheme) {
    throw KakaoClientException(
      'Default browsers only supports URL of http or https scheme.',
    );
  }
  var args = {
    CommonConstants.url: uri.toString(),
    CommonConstants.redirectUri: redirectUri,
    CommonConstants.isPopup: popupOpen,
  };
  args.removeWhere((k, v) => v == null);
  final redirectUriWithParams = await _methodChannel.invokeMethod<String>(
      CommonConstants.launchBrowserTab, args);

  if (redirectUriWithParams != null) return redirectUriWithParams;
  throw KakaoClientException(
      "OAuth 2.0 redirect uri was null, which should not happen.");
}

/// 카카오톡 앱 실행 가능 여부 확인
Future<bool> isKakaoTalkInstalled() async {
  var arguments = {};
  if (kIsWeb) {
    // web does not support platform. so I divided the branch
  } else if (_platform.isAndroid) {
    arguments
        .addAll({'talkPackageName': KakaoSdk.platforms.android.talkPackage});
  } else if (_platform.isIOS) {
    arguments.addAll({'loginScheme': KakaoSdk.platforms.ios.talkLoginScheme});
  }
  return await _methodChannel.invokeMethod<bool>(
          CommonConstants.isKakaoTalkInstalled, arguments) ??
      false;
}

/// @nodoc
Future<Uint8List> platformId() async {
  return await _methodChannel.invokeMethod("platformId");
}

/// @nodoc
// Collection of utility methods, usually for converting data types
class Util {
  static DateTime? fromTimeStamp(int? timestamp) => timestamp == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  static int? fromDateTime(DateTime? dateTime) =>
      dateTime == null ? null : dateTime.millisecondsSinceEpoch ~/ 1000;

  static String? dateTimeWithoutMillis(DateTime? dateTime) => dateTime == null
      ? null
      : "${dateTime.toIso8601String().substring(0, dateTime.toIso8601String().length - 5)}Z";

  static String? mapToString(Map<String, String>? params) => params == null
      ? null
      : Uri(queryParameters: params.map((key, value) => MapEntry(key, value)))
          .query;

  static Map<String, String>? stringToMap(String? params) {
    if (params == null) {
      return null;
    }
    var paramMap = <String, String>{};
    params.split('&').forEach((element) {
      paramMap[element.split('=').first] = element.split('=').last;
    });
    return paramMap;
  }
}
