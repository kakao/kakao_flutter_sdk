import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

import 'story.dart';

class StoryDetailScreen extends StatefulWidget {
  StoryDetailScreen(this.story);
  final Story story;

  @override
  State<StatefulWidget> createState() {
    return StoryDetailState(this.story);
  }
}

class StoryDetailState extends State<StoryDetailScreen> {
  StoryDetailState(this.story);
  Story story;

  @override
  void initState() {
    super.initState();
    _loadStoryDetail(story.id);
  }

  _loadStoryDetail(String id) async {
    final detail = await StoryApi.instance.myStory(id);
    print(detail);
    setState(() {
      story = detail;
    });
  }

  void showDeleteDialog(String id) async {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Delete this story"),
              content: Text("Are you sure you want to delete this story?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteStory(id);
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
  }

  void deleteStory(String id) async {
    try {
      await StoryApi.instance.deleteStory(id);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Id: ${story.id}"),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.delete_simple),
              onPressed: () => showDeleteDialog(story.id),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StoryBox(story, () => {}),
              CommentsList(story.comments)
            ],
          ),
        ));
  }
}

class CommentsList extends StatelessWidget {
  CommentsList(this.comments);
  final List<StoryComment> comments;
  @override
  Widget build(BuildContext context) {
    if (this.comments == null) return Container();
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(color: Colors.grey),
        itemCount: this.comments.length,
        itemBuilder: (BuildContext context, int index) {
          final comment = this.comments[index];
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(
                    comment.writer.profileThumbnailUrl,
                    width: 40,
                    height: 40,
                  ),
                  Column(
                    children: <Widget>[
                      Text(comment.writer.displayName),
                      Text(comment.text)
                    ],
                  )
                ],
              )
            ],
          );
        });
  }
}
