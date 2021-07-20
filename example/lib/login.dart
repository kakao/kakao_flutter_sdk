import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  bool _isKakaoTalkInstalled = true;

  @override
  Widget build(BuildContext context) {
    isKakaoTalkInstalled();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Flutter SDK Login"),
        actions: [],
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
        ],
      )),
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
}
