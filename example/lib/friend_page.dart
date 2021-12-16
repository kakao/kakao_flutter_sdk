import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_example/picker_item.dart';

class FriendPage extends StatefulWidget {
  final List<PickerItem> items;

  const FriendPage({required this.items, Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 선택'),
        actions: [
          GestureDetector(
            onTap: () {
              List<String> selectedItems = [];
              for (var item in widget.items) {
                if (item.checked) {
                  selectedItems.add(item.id);
                }
              }
              Navigator.of(context).pop(selectedItems);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('OK'),
              ),
            ),
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.items[index].label),
              leading: widget.items[index].image != null &&
                      widget.items[index].image != ''
                  ? Image.network(widget.items[index].image!)
                  : Icon(Icons.person),
              trailing: Checkbox(
                value: widget.items[index].checked,
                onChanged: (value) {
                  setState(() {
                    widget.items[index].checked = value!;
                  });
                },
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: widget.items.length),
    );
  }
}
