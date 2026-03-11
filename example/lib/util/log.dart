import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'api_call_context.dart';

class Log {
  static void v(
    BuildContext context,
    String tag,
    String msg, [
    Exception? error,
  ]) {
    developer.log(msg, name: tag, level: 1);
  }

  static void d(String tag, String msg) {
    developer.log(msg, name: tag, level: 2);
  }

  static void i(String tag, String msg, [Object? error]) {
    var message = error == null ? msg : "$msg\n$error";
    developer.log(message, name: tag, level: 3);
    recordApiCallResult(isError: false, message: message);
  }

  static void w(String tag, String msg, [Object? error]) {
    var message = error == null ? msg : "$msg\n$error";
    developer.log(message, name: tag, level: 4);
    recordApiCallResult(isError: false, message: message);
  }

  static void e(String tag, String msg, [Object? error]) {
    var message = error == null ? msg : "$msg\n$error";
    developer.log(message, name: tag, level: 5);
    recordApiCallResult(isError: true, message: message, error: error);
  }
}
