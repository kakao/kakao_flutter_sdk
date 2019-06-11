import 'dart:async';

import 'package:flutter/services.dart';

export 'src/auth/auth_api.dart';
export 'src/auth/access_token_repo.dart';
export 'src/auth/auth_code.dart';
export 'src/user/user_api.dart';
export 'src/talk/talk_api.dart';
export 'src/story/story_api.dart';
export 'src/api_factory.dart';
export 'src/kakao_context.dart';

class KakaoFlutterSdk {
  static const MethodChannel _channel =
      const MethodChannel('kakao_flutter_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
