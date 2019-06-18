import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

class LinkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LinkState();
  }
}

class LinkState extends State<LinkScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("Custom"), onTap: onTapCustom),
        ListTile(title: Text("Default"), onTap: onTapDefault),
        ListTile(title: Text("Scrap"), onTap: onTapScrap)
      ],
    );
  }

  void onTapDefault() async {
    try {
      var uri = await LinkClient.instance
          .custom(16761, templateArgs: {"key1": "value1"});
      await launchWithBrowserTab(uri);
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapCustom() async {
    try {
      var uri = await LinkClient.instance
          .custom(16761, templateArgs: {"key1": "value1"});
      await launchWithBrowserTab(uri);
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapScrap() async {
    try {
      var uri = await LinkClient.instance.scrap("https://developers.kakao.com");
      await launchWithBrowserTab(uri);
    } catch (e) {
      print(e.toString());
    }
  }
}
