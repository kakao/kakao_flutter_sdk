import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/story.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/story_detail.dart';

class StoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
        if (state is NotStoryUser) return Container();
        if (state is StoriesFetched) {
          final _stories = state.stories;
          return BlocListener<StoryDetailBloc, StoryDetailState>(
              listener: (context, state) {
                if (state is StoryDetailFetchStarted) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return StoryDetailScreen();
                  }));
                }
              },
              child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey),
                  itemCount: _stories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StoryBox(_stories[index], () {
                      BlocProvider.of<StoryDetailBloc>(context)
                          .add(FetchStoryDetail(_stories[index]));
                    });
                  }));
        }
        return Container();
      });
}

class StoryDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class StoryBox extends StatelessWidget {
  StoryBox(this.story, this.onTap);
  final Story story;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(this.story.createdAt.toIso8601String()),
                    ],
                  ),
                  Text(this.story.content),
                ],
              ),
            ),
            this.story.media != null
                ? SizedBox(
                    width: double.infinity,
                    child: Image.network(this.story.media[0].large),
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
