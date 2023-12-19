import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/debug_page.dart';
import 'package:kakao_flutter_sdk_example/ui/main_page.dart';
import 'package:kakao_flutter_sdk_example/ui/picker_page.dart';

import './url_strategy_native.dart'
    if (dart.library.html) './url_strategy_web.dart';
import 'ui/kakao_scheme_page.dart';

const Map<String, dynamic> customData = {
  'customMemo': 67020,
  'customMessage': 67020,
  'channelId': '_ZeUTxl',
  'calendarEventId': '63996425afcec577cce94f0b',
  'settle_id': 'f3318663-771a-4b24-8714-3f3061fa17cd',
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  urlConfig();

  KakaoSdk.init(
    nativeAppKey: '030ba7c59137629e86e8721eb1a22fd6',
    javaScriptAppKey: 'fa2d8e9f47b88445000592c9a293bbe2',
    loggingEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget? pageView;
        if (settings.name != null) {
          var data = Uri.parse(settings.name!);
          switch (data.path) {
            case '/':
              pageView = const MainPage(customData: customData);
              break;
            case '/debug':
              pageView = const DebugPage();
              break;
            case '/picker':
              if (data.queryParameters.containsKey('selected')) {
                pageView = PickerPage(result: data.queryParameters['selected']);
              } else if (data.queryParameters.containsKey('error')) {
                pageView = PickerPage(error: data.queryParameters['error']);
              } else {
                pageView = const PickerPage();
              }
              break;
            case '/talkSharing':
              Map<String, dynamic>? params =
                  settings.arguments as Map<String, dynamic>?;
              pageView = KakaoSchemePage(queryParams: params);
              break;
          }
        }
        if (pageView != null) {
          return MaterialPageRoute(builder: (context) => pageView!);
        }
        return null;
      },
    );
  }
}
