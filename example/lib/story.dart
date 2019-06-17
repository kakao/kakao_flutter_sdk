import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

class StoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoryState();
  }
}

class StoryState extends State<StoryScreen> {
  @override
  void initState() {
    super.initState();
    _getStoryProfile();
  }

  StoryProfile _profile;

  _getStoryProfile() async {
    try {
      var isStoryUser = await StoryApi.instance.isStoryUser();
      if (isStoryUser) {
        var profile = await StoryApi.instance.profile();

        setState(() {
          _profile = profile;
        });
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) return Container();
    print(_profile.toJson());
    return Text(_profile.nickname);
  }
}
