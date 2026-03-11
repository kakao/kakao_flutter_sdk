import 'package:example/model/friend_page_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class FriendPage extends StatefulWidget {
  final List<FriendPageItem> items;

  const FriendPage({required this.items, super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  static const double _avatarSize = 56;
  static const int _cachedSize = 56;

  void _submitSelected() {
    final selectedItems = <String>[];
    for (final item in widget.items) {
      if (item.checked) {
        selectedItems.add(item.id);
      }
    }
    context.pop(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarPlaceholder = Container(
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: _avatarSize,
      height: _avatarSize,
      child: const Icon(Icons.person),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('친구 선택'),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        actions: [
          TextButton(
            onPressed: widget.items.any((e) => e.checked)
                ? _submitSelected
                : null,
            child: const Text('OK'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = widget.items[index];

            return ListTile(
              dense: true,
              title: Text(item.label),
              leading: item.image != null && item.image!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.image!,
                        width: _avatarSize,
                        height: _avatarSize,
                        cacheWidth: _cachedSize,
                        cacheHeight: _cachedSize,
                        errorBuilder: (context, error, stackTrace) =>
                            avatarPlaceholder,
                      ),
                    )
                  : avatarPlaceholder,
              trailing: Checkbox(
                value: item.checked,
                onChanged: (value) {
                  setState(() {
                    item.checked = value!;
                  });
                },
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: widget.items.length,
        ),
      ),
    );
  }
}
