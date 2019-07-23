import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

class StoryDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoryDetailState();
  }
}

class StoryDetailState extends State<StoryDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Id: ${story.id}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.delete_simple),
            onPressed: () => {},
          )
        ],
      ),
      body: Text(story.content),
    );
  }
}
