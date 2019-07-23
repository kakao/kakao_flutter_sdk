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
    _checkStoryUser();
  }

  StoryProfile _profile;
  List<Story> _stories;

  _checkStoryUser() async {
    try {
      var isStoryUser = await StoryApi.instance.isStoryUser();
      if (isStoryUser) {
        await _getStoryProfile();
        await _getStories();
      }
    } catch (e) {}
  }

  _getStoryProfile() async {
    var profile = await StoryApi.instance.profile();
    setState(() {
      _profile = profile;
    });
  }

  _getStories() async {
    var stories = await StoryApi.instance.myStories();
    print(stories);
    setState(() {
      _stories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_stories == null) return Container();
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Colors.grey),
        itemCount: _stories.length,
        itemBuilder: (BuildContext context, int index) {
          return StoryBox(_profile, _stories[index]);
        });
  }
}

class StoryDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class StoryBox extends StatelessWidget {
  StoryBox(this.profile, this.story);
  final StoryProfile profile;
  final Story story;

  @override
  Widget build(BuildContext context) {
    print(this.story);
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed("/stories/detail", arguments: this.story);
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(this.story.createdAt),
                    ],
                  ),
                  Text(this.story.content),
                ],
              ),
            ),
            this.story.images != null
                ? SizedBox(
                    width: double.infinity,
                    child: Image.network(this.story.images[0].large),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text("Emotions: ${this.story.likeCount}"),
                  Text("Comments: ${this.story.commentCount}")
                ],
              ),
            )
          ],
        ));
  }
}
