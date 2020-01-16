//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk_plugin.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(PluginRegistry registry) {
  KakaoFlutterSdkPlugin.registerWith(registry.registrarFor(KakaoFlutterSdkPlugin));
  SharedPreferencesPlugin.registerWith(registry.registrarFor(SharedPreferencesPlugin));
  registry.registerMessageHandler();
}
