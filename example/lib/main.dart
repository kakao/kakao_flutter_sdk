import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:kakao_flutter_sdk_example/login.dart';
import 'package:kakao_flutter_sdk_example/story.dart';
import 'package:kakao_flutter_sdk_example/talk.dart';
import 'package:kakao_flutter_sdk_example/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    KakaoContext.clientId = "dd4e9cb75815cbdf7d87ed721a659baf";
    _checkAccessToken();
  }

  _checkAccessToken() async {
    var token = await AccessTokenRepo.instance.fromCache();
    debugPrint("token: ${token.accessToken}");
    debugPrint("token: ${token.refreshToken}");
    if (token.refreshToken == null) {
      Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kakao Flutter SDK Sample",
      initialRoute: "/",
      routes: {
        "/": (context) => MainScreen(),
        "/login": (context) => LoginScreen()
      },
    );
  }

  void _getToken() async {
    try {
      var user = await UserApi(ApiFactory.authApi).me();
      debugPrint(user.kakaoAccount.email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao Flutter SDK Sample'),
      ),
      body: TabBarView(
        controller: _controller,
        children: [UserView(), TalkView(), StoryView()],
      ),
      bottomNavigationBar: TabBar(
        controller: _controller,
        labelColor: Colors.black,
        tabs: [
          Tab(
            icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
            // title: Text("User")
            text: "User",
          ),
          Tab(
            icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
            text: "Talk",
            // title: Text("Talk")
          ),
          Tab(
            icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
            text: "Story",
            // title: Text("Story")
          ),
        ],
        onTap: setTabIndex,
      ),
    );
  }

  void setTabIndex(index) {
    setState(() {
      tabIndex = index;
      _controller.index = tabIndex;
    });
  }
}
