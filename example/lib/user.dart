import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return Container();
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _user != null ? Text(_user.id.toString()) : Container(),
            _user != null && _user.kakaoAccount.email != null
                ? Text(_user.kakaoAccount.email)
                : Container(),
            _user != null && _user.properties["nickname"] != null
                ? Text(_user.properties["nickname"])
                : Container(),
            _user != null && _user.properties["profile_image"] != null
                ? Image.network(_user.properties["profile_image"])
                : Container(),
            RaisedButton(
              child: Text("Logout"),
              onPressed: _logout,
            ),
            RaisedButton(
              child: Text("Unlink"),
              onPressed: _unlink,
            )
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
    } catch (e) {
      debugPrint(e.toString());
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
