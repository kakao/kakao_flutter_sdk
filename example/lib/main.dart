import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_example/bloc_delegate.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/user_bloc/bloc.dart';

import 'add_story.dart';
import 'link.dart';
import 'login.dart';
import 'user.dart';
import 'story.dart';
import 'talk.dart';

void main() {
  KakaoContext.clientId = "dd4e9cb75815cbdf7d87ed721a659baf";
  BlocSupervisor.delegate = MyBlocDelegate();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(
        builder: (context) => UserBloc(),
      ),
      BlocProvider<StoryBloc>(
        builder: (context) => StoryBloc(),
      ),
      BlocProvider<TalkBloc>(
        builder: (context) => TalkBloc(),
      ),
      BlocProvider<FriendsBloc>(
        builder: (context) => FriendsBloc(),
      ),
      BlocProvider<StoryDetailBloc>(
        builder: (context) => StoryDetailBloc(),
      ),
      BlocProvider<PostStoryBloc>(
        builder: (context) => PostStoryBloc(),
      )
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

  String _title = "User API";
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).dispatch(UserFetchStarted());
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.add),
            onPressed: () => {
              Navigator.of(context).push(CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddStoryScreen()))
            },
          )
        ],
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
    String title;

    switch (index) {
      case 0:
        title = "User API";
        BlocProvider.of<UserBloc>(context).dispatch(UserFetchStarted());
        break;
      case 1:
        title = "Talk API";
        BlocProvider.of<TalkBloc>(context).dispatch(FetchTalkProfile());
        BlocProvider.of<FriendsBloc>(context).dispatch(FetchFriends());
        break;
      case 2:
        title = "Story API";
        BlocProvider.of<StoryBloc>(context).dispatch(FetchStories());
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
    });
  }
}
