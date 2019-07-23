import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

class AddStoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddStoryState();
  }
}

class AddStoryState extends State<AddStoryScreen> {
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
      var result = await StoryApi.instance.post(
          content: _contentController.text,
          permission: _selectedPermission,
          enableShare: _enableShare,
          androidExecParams: _androidExecController.text,
          iosExecParams: _iosExecController.text);
      print(result);
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
          child: Column(
            children: <Widget>[
              TextField(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 20),
              DropdownButton(
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
              TextField(
                controller: _androidExecController,
                decoration: InputDecoration(labelText: "Android Exec Params"),
              ),
              TextField(
                controller: _iosExecController,
                decoration: InputDecoration(labelText: "iOS Exec Params"),
              )
            ],
          ),
        ));
  }
}
