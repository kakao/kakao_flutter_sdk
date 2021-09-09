import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk_example/server_phase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  static final _platform = const MethodChannel('kakao.flutter.sdk.sample');
  String currentPhase = '';
  bool _isKakaoTalkInstalled = true;

  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
    _getCurrentPhase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getCurrentPhase() async {
    var prefs = await SharedPreferences.getInstance();
    var phase = prefs.getString('KakaoPhase');
    setState(() {
      if (phase == null) {
        currentPhase = "PRODUCTION";
      } else {
        currentPhase = phase;
      }
    });
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  @override
  Widget build(BuildContext context) {
    isKakaoTalkInstalled();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Flutter SDK Login"),
        actions: [
          TextButton(
            child: Text(currentPhase),
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                        height: 300,
                        child: Column(children: [
                          _buildListTile(context, KakaoPhase.DEV),
                          _buildListTile(context, KakaoPhase.SANDBOX),
                          _buildListTile(context, KakaoPhase.CBT),
                          _buildListTile(context, KakaoPhase.PRODUCTION),
                        ]));
                  });
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(child: Text("Login"), onPressed: _loginWithKakao),
          RaisedButton(
              child: Text("Login(prompts:)"),
              onPressed: _loginWithKakaoPrompts),
          RaisedButton(
              child: Text("Login with Talk"),
              onPressed: _isKakaoTalkInstalled ? _loginWithTalk : null),
          RaisedButton(
              child: Text("CertLoginTalk"),
              onPressed: _isKakaoTalkInstalled ? _certLoginWithTalk : null),
          RaisedButton(
              child: Text("CertLogin"), onPressed: _certLoginWithKakao),
        ],
      )),
    );
  }

  ListTile _buildListTile(BuildContext context, KakaoPhase phase) {
    var title;
    if (phase == KakaoPhase.DEV) {
      title = "DEV";
    } else if (phase == KakaoPhase.SANDBOX) {
      title = "SANDBOX";
    } else if (phase == KakaoPhase.CBT) {
      title = "CBT";
    } else {
      title = "PRODUCTION";
    }
    return ListTile(
      title: Text(title),
      onTap: () async {
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString('KakaoPhase', title);
        KakaoContext.clientId = PhasedAppKey(phase).getAppKey();
        KakaoContext.hosts = PhasedServerHosts(phase);
        Navigator.pop(context);
        setState(() {
          currentPhase = title;
        });
        await _platform.invokeMethod('changePhase');
      },
    );
  }

  _loginWithKakao() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      print('error on login: $e');
    }
  }

  _loginWithKakaoPrompts() async {
    try {
      await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.LOGIN]);
      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      print('error on login: $e');
    }
  }

  _loginWithTalk() async {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      print('error on login: $e');
    }
  }

  _certLoginWithTalk() async {
    final info = await UserApi.instance.certLoginWithKakaoTalk(state: "test");
    print("${info.token.accessToken}");
    print("${info.txId}");
    Navigator.of(context).pushReplacementNamed("/main");
    try {} catch (e) {
      print('error on login: $e');
    }
  }

  _certLoginWithKakao() async {
    try {
      final info =
          await UserApi.instance.certLoginWithKakaoAccount(state: 'test');
      print("${info.token.accessToken}");
      print("${info.txId}");
      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      print('error on login: $e');
    }
  }
}
