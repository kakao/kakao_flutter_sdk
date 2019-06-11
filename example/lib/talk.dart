import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

class TalkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TalkState();
  }
}

class TalkState extends State<TalkScreen> {
  TalkProfile _profile;
  @override
  void initState() {
    super.initState();
    _getTalkProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) return Container();
    return Column(
      children: <Widget>[
        Text(_profile.nickname),
        Image.network(_profile.profileImageUrl),
        Image.network(_profile.thumbnailUrl),
        Text(_profile.countryISO)
      ],
    );
  }

  _getTalkProfile() async {
    try {
      var profile = await TalkApi.instance.profile();

      setState(() {
        _profile = profile;
      });
    } catch (e) {}
  }
}
