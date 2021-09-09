import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk_example/search_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/server_phase.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/user_bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_story.dart';
import 'link.dart';
import 'login.dart';
import 'search.dart';
import 'server_phase.dart';
import 'story.dart';
import 'talk.dart';
import 'user.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(create: (context) => UserBloc()),
      BlocProvider<StoryBloc>(create: (context) => StoryBloc()),
      BlocProvider<TalkBloc>(create: (context) => TalkBloc()),
      BlocProvider<FriendsBloc>(create: (context) => FriendsBloc()),
      BlocProvider<StoryDetailBloc>(
        create: (context) => StoryDetailBloc(),
      ),
      BlocProvider<PostStoryBloc>(
        create: (context) => PostStoryBloc(),
      ),
      BlocProvider<SearchBloc>(create: (context) => SearchBloc())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initializeSdk();
  }

  _initializeSdk() async {
    KakaoPhase phase = await _getKakaoPhase();
    KakaoContext.hosts = PhasedServerHosts(phase);
    KakaoContext.clientId = PhasedAppKey(phase).getAppKey();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kakao Flutter SDK Sample",
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/main": (context) => MainScreen(),
        "/login": (context) => LoginScreen(),
        "/stories/post": (context) => AddStoryScreen(),
        // "/stories/detail": (context) => StoryDetailScreen()
      },
    );
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
    if (kIsWeb) {
      AuthCodeClient.instance.retrieveAuthCode();
    }
    _checkAccessToken();
  }

  _checkAccessToken() async {
    var token = await TokenManager.instance.getToken();
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

  String _title = "User API";

  List<Widget> _actions = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(UserFetchStarted());
    _controller = TabController(length: 4, vsync: this);
    _actions = _searchActions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoggedOut) {
          Navigator.of(context).pushReplacementNamed("/login");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: _actions,
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
              text: "User",
            ),
            Tab(
              icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
              text: "Talk",
            ),
            Tab(
              icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
              text: "Story",
            ),
            Tab(
              icon: Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
              text: "Link",
            )
          ],
          onTap: setTabIndex,
        ),
      ),
    );
  }

  List<Widget> _searchActions() {
    return [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context,
                delegate: DataSearch(BlocProvider.of<SearchBloc>(context)));
          })
    ];
  }

  List<Widget> _storyActions() {
    return [
      IconButton(
        icon: Icon(CupertinoIcons.add),
        onPressed: () => {
          Navigator.of(context).push(CupertinoPageRoute(
              fullscreenDialog: true, builder: (context) => AddStoryScreen()))
        },
      )
    ];
  }

  void setTabIndex(index) {
    String title;

    List<Widget> actions = _searchActions();
    switch (index) {
      case 0:
        title = "User API";
        BlocProvider.of<UserBloc>(context).add(UserFetchStarted());
        break;
      case 1:
        title = "Talk API";
        BlocProvider.of<TalkBloc>(context).add(FetchTalkProfile());
        BlocProvider.of<FriendsBloc>(context).add(FetchFriends());
        break;
      case 2:
        title = "Story API";
        BlocProvider.of<StoryBloc>(context).add(FetchStories());
        actions = _storyActions();
        break;
      case 3:
        title = "KakaoLink";
        break;
      default:
    }
    setState(() {
      tabIndex = index;
      _controller.index = tabIndex;
      _title = title;
      if (actions != null) {
        _actions = actions;
      }
    });
  }
}
