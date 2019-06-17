import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

import 'link.dart';
import 'login.dart';
import 'user.dart';
import 'story.dart';
import 'talk.dart';

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
    KakaoContext.clientId = "030ba7c59137629e86e8721eb1a22fd6";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kakao Flutter SDK Sample",
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/main": (context) => MainScreen(),
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

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }

  _checkAccessToken() async {
    var token = await AccessTokenRepo.instance.fromCache();
    debugPrint(token.toString());
    if (token.refreshToken == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed("/main");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
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
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao Flutter SDK Sample'),
      ),
      body: TabBarView(
        controller: _controller,
        children: [UserScreen(), TalkScreen(), StoryScreen(), LinkScreen()],
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
          Tab(
            icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
            text: "Link",
          )
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
