import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/story_detail_bloc.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/story_detail_event.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/story_detail_state.dart';

import 'story.dart';

class StoryDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StoryDetailBloc, StoryDetailState>(
        builder: (context, state) {
          final story = state is StoryDetailFetched
              ? state.storyDetail
              : state is StoryDetailFetchStarted ? state.simpleStory : null;
          if (state is StoryDetailFetchFailed) return Container();
          return BlocListener<StoryDetailBloc, StoryDetailState>(
              listener: (context, state) {
                if (state is StoryDeleted) {
                  Navigator.of(context).pop();
                }
              },
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("Id: ${story.id}"),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(CupertinoIcons.delete_simple),
                        onPressed: () => showDeleteDialog(context, story),
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
                  )));
        },
      );

  void showDeleteDialog(BuildContext context, Story story) async {
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
                    BlocProvider.of<StoryDetailBloc>(context)
                        .dispatch(DeleteStory(story));
                    // deleteStory(id);
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
}
//   void deleteStory(String id) async {
//     try {
//       await StoryApi.instance.deleteStory(id);
//       Navigator.of(context).pop();
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// class _StoryDetailState extends State<StoryDetailScreen> {
//   _StoryDetailState(this.story);
//   Story story;

//   @override
//   void initState() {
//     super.initState();
//     _loadStoryDetail(story.id);
//   }

//   _loadStoryDetail(String id) async {
//     final detail = await StoryApi.instance.myStory(id);
//     print(detail);
//     setState(() {
//       story = detail;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Id: ${story.id}"),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(CupertinoIcons.delete_simple),
//               onPressed: () => showDeleteDialog(story.id),
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               StoryBox(story, () => {}),
//               CommentsList(story.comments)
//             ],
//           ),
//         ));
//   }
// }

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
