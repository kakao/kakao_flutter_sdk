import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/story.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/post_story_bloc.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/post_story_event.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/post_story_state.dart';

class AddStoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddStoryState();
  }
}

class AddStoryState extends State<AddStoryScreen> {
  final _contentController = TextEditingController();
  final _androidExecController = TextEditingController();
  final _iosExecController = TextEditingController();

  PostStoryBloc _bloc;
  List<DropdownMenuItem<StoryPermission>> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      StoryPermission.PUBLIC,
      StoryPermission.FRIEND,
      StoryPermission.ONLY_ME
    ]
        .map((item) =>
            DropdownMenuItem(value: item, child: Text(item.toString())))
        .toList();

    _bloc = BlocProvider.of(context);
    _contentController.addListener(_onContentChanged);
    _androidExecController.addListener(_onAndroidParamsChanged);
    _iosExecController.addListener(_onIosParamsChanged);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _androidExecController.dispose();
    _iosExecController.dispose();
    super.dispose();
  }

  Future<File> fileFromAsset(final String path) async {
    final data = await rootBundle.load(path);
    final tempDir = Directory.systemTemp.path;
    final pathSegs = path.split("/");
    final fileName = pathSegs[pathSegs.length - 1];
    final file = File("$tempDir/$fileName");
    await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostStoryBloc, PostStoryState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<PostStoryBloc>(context);
        return BlocListener<PostStoryBloc, PostStoryState>(
            listener: (context, state) {
              if (state.posted == true) {
                Navigator.of(context).pop();
                return;
              }
              if (state.exception != null) {
                _showErrorDialog(state.exception);
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Add a Story"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(CupertinoIcons.check_mark),
                      onPressed: () => {bloc.add(PostStory())},
                    )
                  ],
                ),
                body: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _contentController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: "Content"),
                        maxLines: 10,
                        minLines: 1,
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value:
                                state.images.contains("assets/images/cat1.png"),
                            onChanged: (selected) {
                              bloc.add(SetImages(
                                  fileFromAsset("assets/images/cat1.png"),
                                  selected));
                            },
                          ),
                          Image.asset(
                            "assets/images/cat1.png",
                            width: 130,
                          ),
                          Checkbox(
                            value:
                                state.images.contains("assets/images/cat2.png"),
                            onChanged: (selected) {
                              bloc.add(SetImages(
                                  fileFromAsset("assets/images/cat2.png"),
                                  selected));
                            },
                          ),
                          Image.asset(
                            "assets/images/cat2.png",
                            width: 130,
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        value: state.permission,
                        items: _items,
                        onChanged: (val) {
                          bloc.add(SetStoryPermission(val));
                        },
                      ),
                      Switch(
                        value: state.enableShare,
                        onChanged: (val) {
                          bloc.add(SetEnableShare(val));
                        },
                      ),
                      TextFormField(
                        controller: _androidExecController,
                        decoration:
                            InputDecoration(labelText: "Android Exec Params"),
                      ),
                      TextFormField(
                        controller: _iosExecController,
                        decoration:
                            InputDecoration(labelText: "iOS Exec Params"),
                      )
                    ],
                  ),
                ))));
      },
    );
  }

  _onContentChanged() {
    _bloc.add(SetContent(_contentController.text));
  }

  _onAndroidParamsChanged() {
    _bloc.add(SetAndroidExecParams(_androidExecController.text));
  }

  _onIosParamsChanged() {
    _bloc.add(SetIosExecParams(_iosExecController.text));
  }

  _showErrorDialog(Exception e) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Story post error"),
              content: Text(e.toString()),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Close"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }
}
