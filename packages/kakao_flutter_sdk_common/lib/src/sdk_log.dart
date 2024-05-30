import 'dart:collection';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';

/// @nodoc
enum SdkLogLevel { v, d, i, w, e }

/// @nodoc
extension SdkLogLevelExtension on SdkLogLevel {
  int get level {
    switch (this) {
      case SdkLogLevel.v:
        return 0;
      case SdkLogLevel.d:
        return 1;
      case SdkLogLevel.i:
        return 2;
      case SdkLogLevel.w:
        return 3;
      case SdkLogLevel.e:
        return 4;
    }
  }

  String get prefix {
    switch (this) {
      case SdkLogLevel.v:
        return "[\uD83D\uDCAC]";
      case SdkLogLevel.d:
        return "[ℹ️]";
      case SdkLogLevel.i:
        return "[\uD83D\uDD2C]";
      case SdkLogLevel.w:
        return "[⚠️]";
      case SdkLogLevel.e:
        return "[‼️]";
    }
  }
}

/// @nodoc
class SdkLog {
  static final bool _enabled = KakaoSdk.logging;

  static final LinkedList<LogData> _logs = LinkedList();

  static const int _maxSize = 100;

  SdkLog._();

  static Future<String> get logs async {
    return '==== sdk version: ${KakaoSdk.sdkVersion}\n==== app version: ${await KakaoSdk.appVer}\n${_logs.join("\n")}';
  }

  static void v(Object? logged) => _log(logged, SdkLogLevel.v);

  static void d(Object? logged) => _log(logged, SdkLogLevel.d);

  static void i(Object? logged) => _log(logged, SdkLogLevel.i);

  static void w(Object? logged) => _log(logged, SdkLogLevel.w);

  static void e(Object? logged) => _log(logged, SdkLogLevel.e);

  static void _log(Object? logged, SdkLogLevel logLevel) {
    String log = "${logLevel.prefix} $logged";

    if (kDebugMode && _enabled) {
      developer.log(log, level: logLevel.level);
    }
    if (_enabled && logLevel.level >= SdkLogLevel.i.level) {
      String currentTime = DateTime.now().toString();
      // format time to [MM-dd HH:mm:ss.SSS]
      String loggingTime = currentTime.substring(0, currentTime.length - 3);
      _logs.add(LogData("$loggingTime $log"));
      if (_logs.length > _maxSize) {
        _logs.remove(_logs.first);
      }
    }
  }

  static void clear() => _logs.clear();
}

/// @nodoc
final class LogData extends LinkedListEntry<LogData> {
  String log;

  LogData(this.log);

  @override
  String toString() {
    return log;
  }
}
