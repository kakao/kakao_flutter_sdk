import 'package:flutter/material.dart';

class ParameterDialog extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Function(Map<String, Object> parameters) callback;
  final Map<String, Object> result = {};

  ParameterDialog({
    required this.title,
    required this.items,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Center(child: Text(title)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...items,
              actions(context),
            ],
          ),
        ),
      ),
      insetPadding: const EdgeInsets.all(16.0),
      titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      contentPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
    );
  }

  Widget actions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: actionButton(
              'Close',
              () => Navigator.of(context).pop(),
              backgroundColor: Colors.grey,
            ),
          ),
          Expanded(
            flex: 2,
            child: actionButton(
              'Request',
              () => Navigator.of(context).pop(callback(result)),
              backgroundColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton(String text, VoidCallback onPressed,
      {Color? backgroundColor, int? flex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        child: Text(text),
      ),
    );
  }
}
