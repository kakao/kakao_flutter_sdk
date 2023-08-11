import 'package:flutter/material.dart';

class TextFieldItem extends StatefulWidget {
  final String title;
  final double fontSize;
  final String? hintText;
  final bool switchChecked;
  final ValueChanged<String>? onValueChanged;
  final bool visible;
  final bool editable;

  const TextFieldItem({
    required this.title,
    required this.fontSize,
    this.onValueChanged,
    this.switchChecked = false,
    this.hintText,
    this.editable = true,
    this.visible = false,
    super.key,
  });

  @override
  State<TextFieldItem> createState() => _TextFieldItemState();
}

class _TextFieldItemState extends State<TextFieldItem> {
  late var _isChecked = widget.switchChecked;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });

                if (_isChecked) {
                  widget.onValueChanged?.call(_controller.text);
                }
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 1,
            child:
                Text(widget.title, style: TextStyle(fontSize: widget.fontSize)),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: TextField(
              enabled: widget.editable,
              decoration: InputDecoration(
                hintText: widget.hintText,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              ),
              onChanged: (value) {
                if (_isChecked) {
                  widget.onValueChanged?.call(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
