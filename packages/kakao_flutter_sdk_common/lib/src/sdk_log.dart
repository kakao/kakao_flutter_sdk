import 'dart:collection';
import 'dart:developer' as developer;

import 'kakao_sdk.dart';

/// @nodoc
enum SdkLogLevel {
  v('[\uD83D\uDCAC]', 0),
  d('[ℹ️]', 1),
  i('[\uD83D\uDD2C]', 2),
  w('[⚠️]', 3),
  e('[‼️]', 4);

  const SdkLogLevel(this.prefix, this.level);

  final int level;
  final String prefix;
}

/// @nodoc
class SdkLog {
  static bool get _enabled => KakaoSdk.logging;

  static final List<LogData> _logs = [];

  static const int _maxSize = 100;

  SdkLog._();

  static String get logs {
    return '==== sdk version: ${KakaoSdk.sdkVersion} ====\n==== app version: ${KakaoSdk.platformInfo.appVer} ====\n${_logs.join('\n')}';
  }

  static void v(Object? logged) => _log(logged, SdkLogLevel.v);

  static void d(Object? logged) => _log(logged, SdkLogLevel.d);

  static void i(Object? logged) => _log(logged, SdkLogLevel.i);

  static void w(Object? logged) => _log(logged, SdkLogLevel.w);

  static void e(Object? logged) => _log(logged, SdkLogLevel.e);

  static void _log(Object? logged, SdkLogLevel logLevel) {
    final log = '${logLevel.prefix} $logged';

    if (_enabled) {
      developer.log(log, level: logLevel.level);
    }
    if (_enabled && logLevel.level >= SdkLogLevel.i.level) {
      final currentTime = DateTime.now().toString();
      // [MM-dd HH:mm:ss.SSS] 형식으로 변환. (년도, 타임존 제거)
      final time = currentTime.substring(5, currentTime.length - 3);
      _logs.add(LogData('$time $log'));

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
