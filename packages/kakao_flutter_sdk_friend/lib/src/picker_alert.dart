import 'package:flutter/material.dart';

/// @nodoc
class PickerAlert extends StatelessWidget {
  final String title;
  final String message;
  final String confirm;

  const PickerAlert({
    Key? key,
    required this.title,
    required this.message,
    required this.confirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(confirm),
        ),
      ],
    );
  }
}
