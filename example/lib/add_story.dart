import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/main.dart';

class AddStoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddStoryState();
  }
}

class AddStoryState extends State<AddStoryScreen> {
  bool _image1Selected = false;
  bool _image2Selected = false;

  List<String> _imagesToupload = List();

  StoryPermission _selectedPermission;
  bool _enableShare;
  final _contentController = TextEditingController();
  final _androidExecController = TextEditingController();
  final _iosExecController = TextEditingController();

  List<DropdownMenuItem<StoryPermission>> _items;

  @override
  void initState() {
    super.initState();
    _selectedPermission = StoryPermission.PUBLIC;
    _enableShare = true;
    _items = [
      StoryPermission.PUBLIC,
      StoryPermission.FRIEND,
      StoryPermission.ONLY_ME
    ]
        .map((item) =>
            DropdownMenuItem(value: item, child: Text(item.toString())))
        .toList();
  }

  @override
  void dispose() {
    _androidExecController.dispose();
    _iosExecController.dispose();
    super.dispose();
  }

  void _postStory() async {
    try {
      var images;
      if (_imagesToupload.isNotEmpty) {
        var files = _imagesToupload.map((path) async {
          return await fileFromAsset(path);
        });
        images = await StoryApi.instance.scrapImages(await Future.wait(files));
      }
      var result = await StoryApi.instance.post(
          content: _contentController.text,
          images: images,
          permission: _selectedPermission,
          enableShare: _enableShare,
          androidExecParams: _androidExecController.text,
          iosExecParams: _iosExecController.text);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
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

  void onImage1Selected(selected) {
    setState(() {
      _image1Selected = selected;
      _imagesToupload.remove("assets/images/cat1.png");
      _imagesToupload.add("assets/images/cat1.png");
    });
  }

  void onImage2Selected(selected) {
    setState(() {
      setState(() {
        _image2Selected = selected;
        _imagesToupload.remove("assets/images/cat2.png");
        _imagesToupload.add("assets/images/cat2.png");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a Story"),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.check_mark),
              onPressed: () => {_postStory()},
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
                    value: _image1Selected,
                    onChanged: onImage1Selected,
                  ),
                  Image.asset(
                    "assets/images/cat1.png",
                    width: 130,
                  ),
                  Checkbox(
                    value: _image2Selected,
                    onChanged: onImage2Selected,
                  ),
                  Image.asset(
                    "assets/images/cat2.png",
                    width: 130,
                  ),
                ],
              ),
              DropdownButtonFormField(
                value: _selectedPermission,
                items: _items,
                onChanged: (val) {
                  setState(() {
                    _selectedPermission = val;
                  });
                },
              ),
              Switch(
                value: _enableShare,
                onChanged: (val) {
                  setState(() {
                    _enableShare = val;
                  });
                },
              ),
              TextFormField(
                controller: _androidExecController,
                decoration: InputDecoration(labelText: "Android Exec Params"),
              ),
              TextFormField(
                controller: _iosExecController,
                decoration: InputDecoration(labelText: "iOS Exec Params"),
              )
            ],
          ),
        )));
  }
}
