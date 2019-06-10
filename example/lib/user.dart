import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kakao_flutter_sdk/main.dart';

class UserView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserState();
  }
}

class _UserState extends State<UserView> {
  User _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_user.properties.toString());
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (_user != null) Text(_user.id.toString()),
            if (_user != null) Text(_user.kakaoAccount.email),
            if (_user != null && _user.properties["nickname"] != null)
              Text(_user.properties["nickname"]),
            if (_user != null && _user.properties["profile_image"] != null)
              Image.network(_user.properties["profile_image"])
          ],
        ));
  }

  void _getUser() async {
    try {
      var user = await UserApi(ApiFactory.authApi).me();

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
    // TODO: implement build

    Map<String, String> properties = _user.properties;
    return Column(
      children: <Widget>[
        _user != null ? Text(_user.id.toString()) : Container(),
      ],
    );
  }
}
