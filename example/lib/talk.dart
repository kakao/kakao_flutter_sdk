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
        Text(_profile.countryISO),
        RaisedButton(
          child: Text("custom"),
          onPressed: _customMemo,
        ),
        RaisedButton(
          child: Text("default"),
          onPressed: _defaultMemo,
        )
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

  _customMemo() async {
    try {
      await TalkApi.instance
          .customMemo(16761, {"MESSAGE_TITLE": "FROM Flutter SDK Example"});
    } catch (e) {}
  }

  _defaultMemo() async {
    FeedTemplate template = FeedTemplate(Content(
        "Default Feed Template",
        "http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png",
        Link()));
    try {
      await TalkApi.instance.defaultMemo(template);
    } catch (e) {
      print(e.toString());
    }
  }
}
