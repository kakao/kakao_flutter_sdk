import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk/main.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserState();
  }
}

class _UserState extends State<UserScreen> {
  User _user;
  AccessTokenInfo _tokenInfo;

  @override
  void initState() {
    super.initState();
    _getUser();
    _getTokenInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return Container();
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountEmail: Text(_user.kakaoAccount.email),
                accountName: Text(_user.properties["nickname"]),
                currentAccountPicture: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage(_user.properties["profile_image"]))),
            _user != null ? Text(_user.id.toString()) : Container(),
            TokenInfoBox(_tokenInfo),
            RaisedButton(
              child: Text("Logout"),
              onPressed: _logout,
            ),
            RaisedButton(
              child: Text("Unlink"),
              onPressed: _unlink,
            ),
          ],
        ));
  }

  _logout() async {
    try {
      await UserApi.instance.logout();
      AccessTokenRepo.instance.clear();
      Navigator.of(context).pushReplacementNamed("/login");
    } catch (e) {}
  }

  _unlink() async {
    try {
      await UserApi.instance.unlink();
      AccessTokenRepo.instance.clear();
      Navigator.of(context).pushReplacementNamed("/login");
    } catch (e) {}
  }

  _getUser() async {
    try {
      var user = await UserApi.instance.me();
      setState(() {
        _user = user;
      });
    } on KakaoApiException catch (e) {
      if (e.code == ApiErrorCause.INVALID_TOKEN) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _getTokenInfo() async {
    try {
      var tokenInfo = await UserApi.instance.accessTokenInfo();
      setState(() {
        _tokenInfo = tokenInfo;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

class UserProfile extends StatelessWidget {
  User _user;

  @override
  Widget build(BuildContext context) {
    Map<String, String> properties = _user.properties;
    return Column(
      children: <Widget>[
        _user != null ? Text(_user.id.toString()) : Container(),
      ],
    );
  }
}

class TokenInfoBox extends StatelessWidget {
  TokenInfoBox(this.tokenInfo);
  final AccessTokenInfo tokenInfo;
  @override
  Widget build(BuildContext context) {
    if (tokenInfo == null) return Container();
    return Column(
      children: <Widget>[
        Text("App id: ${tokenInfo.appId}"),
        Text(
            "Token expires in: ${(tokenInfo.expiresInMillis / 1000).floor()} seconds.")
      ],
    );
  }
}
