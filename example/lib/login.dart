import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenRepo.instance.toCache(token);
      Navigator.of(context).pushReplacementNamed("/main");
    } catch (e) {
      print("error on issuing access token: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
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
    var code = await AuthCodeClient().request();
    _issueAccessToken(code);
  }
}
