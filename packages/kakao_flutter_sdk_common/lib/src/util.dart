import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/src/constants.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_exception.dart';

const MethodChannel _channel = MethodChannel(CommonConstants.methodChannel);

/// 플랫폼별 기본 브라우저로 URL 실행
Future<String> launchBrowserTab(Uri uri, {String? redirectUri}) async {
  if (uri.scheme != CommonConstants.http &&
      uri.scheme != CommonConstants.scheme) {
    throw KakaoClientException(
      'Default browsers only supports URL of http or https scheme.',
    );
  }
  var args = {
    CommonConstants.url: uri.toString(),
    CommonConstants.redirectUri: redirectUri
  };
  args.removeWhere((k, v) => v == null);
  final redirectUriWithParams = await _channel.invokeMethod<String>(
      CommonConstants.launchBrowserTab, args);

  if (redirectUriWithParams != null) return redirectUriWithParams;
  throw KakaoClientException(
      "OAuth 2.0 redirect uri was null, which should not happen.");
}

/// 카카오톡이 설치되어 있는지 여부 확인
Future<bool> isKakaoTalkInstalled() async {
  final isInstalled =
      await _channel.invokeMethod<bool>(CommonConstants.isKakaoTalkInstalled) ??
          false;
  return isInstalled;
}

/// @nodoc
Future<Uint8List> platformId() async {
  return await _channel.invokeMethod("platformId");
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
