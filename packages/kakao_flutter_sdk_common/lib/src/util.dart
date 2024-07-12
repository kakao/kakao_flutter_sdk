import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/src/constants.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';
import 'package:platform/platform.dart';

/// @nodoc
const MethodChannel _methodChannel =
    MethodChannel(CommonConstants.methodChannel);
const _platform = LocalPlatform();

/// KO: 실행 중이지 않은 앱을 커스텀 URL 스킴 호출로 실행할 때 URL 전달
/// <br>
/// EN: Pass the URL when launching a closed app with a custom URL scheme
Future<String?> receiveKakaoScheme() async {
  if (kIsWeb) {
    return null;
  }
  return await _methodChannel.invokeMethod(CommonConstants.receiveKakaoScheme);
}

/// KO: 실행 중인 앱을 커스텀 URL 스킴 호출로 실행할 때 URL 전달
/// <br>
/// EN: Pass the URL when launching a running app with a custom URL scheme
Stream<String?> get kakaoSchemeStream {
  if (kIsWeb) {
    return Stream.value(null);
  }

  return const EventChannel(CommonConstants.eventChannel)
      .receiveBroadcastStream()
      .map<String?>((link) => link as String?);
}

/// KO: 기본 브라우저로 URL 실행<br>
/// [popupOpen]이 true면 URL을 팝업에서 실행. [popupOpen]은 웹에서만 사용 가능<br>
/// <br>
/// EN: Launchs a URL with the default browser<br>
/// Execute the URL with a pop-up if [popupOpen] is set true. [popupOpen] is only available on the web
Future launchBrowserTab(Uri uri, {bool popupOpen = false}) async {
  if (uri.scheme != CommonConstants.http &&
      uri.scheme != CommonConstants.scheme) {
    throw KakaoClientException(
      ClientErrorCause.notSupported,
      'Default browsers only supports URL of http or https scheme.',
    );
  }
  final args = {
    CommonConstants.url: uri.toString(),
    CommonConstants.isPopup: popupOpen,
  };

  await _methodChannel.invokeMethod<String>(
      CommonConstants.launchBrowserTab, args);
}

/// KO: 카카오톡 앱 실행 가능 여부 조회
/// <br>
/// EN: Returns whether Kakao Talk is available to launch
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
bool isMobileWeb() {
  return kIsWeb && (isAndroid() || isiOS());
}

/// @nodoc
bool isAndroid() {
  return defaultTargetPlatform == TargetPlatform.android;
}

/// @nodoc
bool isiOS() {
  return defaultTargetPlatform == TargetPlatform.iOS;
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
