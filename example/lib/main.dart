import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/api_item.dart';
import 'package:kakao_flutter_sdk_example/debug_page.dart';
import 'package:kakao_flutter_sdk_example/server_phase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server_phase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeSdk();

  runApp(MyApp());
}

Future _initializeSdk() async {
  KakaoPhase phase = await _getKakaoPhase();
  KakaoSdk.init(
    nativeAppKey: PhasedAppKey(phase).getAppKey(),
    serviceHosts: PhasedServerHosts(phase),
    loggingEnabled: true,
  );
}

Future<KakaoPhase> _getKakaoPhase() async {
  var prefs = await SharedPreferences.getInstance();
  var prevPhase = prefs.getString('KakaoPhase');
  print('$prevPhase');
  KakaoPhase phase;
  if (prevPhase == null) {
    phase = KakaoPhase.PRODUCTION;
  } else {
    if (prevPhase == "DEV") {
      phase = KakaoPhase.DEV;
    } else if (prevPhase == "SANDBOX") {
      phase = KakaoPhase.SANDBOX;
    } else if (prevPhase == "CBT") {
      phase = KakaoPhase.CBT;
    } else {
      phase = KakaoPhase.PRODUCTION;
    }
  }
  return phase;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (_) => MyPage(), '/debug': (_) => DebugPage()},
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<ApiItem> apiList = [];

  @override
  void initState() {
    super.initState();
    _initApiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SDK Sample'),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('DEBUG'),
              ),
            ),
            onTap: () => Navigator.of(context).pushNamed('/debug'),
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
                title: Text(apiList[index].label),
                onTap: apiList[index].apiFunction,
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: apiList.length),
    );
  }

  _initApiList() {
    apiList = [];
  }
}
