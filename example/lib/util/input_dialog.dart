import 'package:flutter/material.dart';

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
  String? labelText,
}) async {
  final String? input = await showDialog<String>(
    context: context,
    builder: (context) => _TextInputDialog(
      title: title,
      initialValue: initialValue,
      labelText: labelText,
    ),
  );

  final String? trimmed = input?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    this.initialValue,
    this.labelText,
  });

  final String title;
  final String? initialValue;
  final String? labelText;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  )..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.initialValue?.length ?? 0,
    );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) => Navigator.of(context).pop(value);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.labelText),
        onSubmitted: _submit,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => _submit(_controller.text),
          child: const Text('확인'),
        ),
      ],
    );
  }
}
