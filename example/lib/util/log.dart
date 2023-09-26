import 'dart:developer' as developer;

import 'package:flutter/material.dart';

class Log {
  static void v(BuildContext context, String tag, String msg,
      [Exception? error]) {
    developer.log(msg, name: tag, level: 1);
  }

  static void d(BuildContext context, String tag, String msg) {
    developer.log(msg, name: tag, level: 2);
  }

  static void i(BuildContext context, String tag, String msg, [Object? error]) {
    var message = error == null ? msg : "$msg\n$error";
    developer.log(message, name: tag, level: 3);
    _showSnackBar(context, message);
  }

  static void w(BuildContext context, String tag, String msg, [Object? error]) {
    var message = error == null ? msg : "$msg\n$error";
    developer.log(message, name: tag, level: 4);
    _showSnackBar(context, message);
  }

  static void e(BuildContext context, String tag, String msg, [Object? error]) {
    var message = error == null ? msg : "$msg\n$error";
    developer.log(message, name: tag, level: 5);
    _showSnackBar(context, message);
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
