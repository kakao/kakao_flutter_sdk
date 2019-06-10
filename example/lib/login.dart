import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:uni_links/uni_links.dart';

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
    _onUniLinks();
  }

  StreamSubscription _sub;
  _onUniLinks() async {
    _sub = getUriLinksStream().listen((Uri uri) {
      var code = uri.queryParameters["code"];
      if (code != null) {
        _issueAccessToken(code);
      }
    }, onDone: () => {}, onError: (err, st) => {}, cancelOnError: true);
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      print("after token");
      AccessTokenRepo.instance.toCache(token);
      Navigator.of(context).pushReplacementNamed("/");
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Flutter SDK Login"),
      ),
      body: Center(
        child: RaisedButton(child: Text("Login"), onPressed: _loginWithKakao),
      ),
    );
  }

  _loginWithKakao() async {
    AuthCodeClient().launchAutorizeUrl();
  }
}
