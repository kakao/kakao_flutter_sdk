import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/debug_page.dart';
import 'package:kakao_flutter_sdk_example/ui/main_page.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: '030ba7c59137629e86e8721eb1a22fd6',
    loggingEnabled: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => MainPage(),
        '/debug': (_) => DebugPage(),
      },
    );
  }
}
