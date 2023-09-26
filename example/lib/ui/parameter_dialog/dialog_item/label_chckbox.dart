import 'package:flutter/material.dart';

class LabelCheckbox extends StatefulWidget {
  final String label;
  final ValueChanged<bool?>? onCheckChanged;

  const LabelCheckbox({required this.label, this.onCheckChanged, super.key});

  @override
  State<LabelCheckbox> createState() => _LabelCheckboxState();
}

class _LabelCheckboxState extends State<LabelCheckbox> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Checkbox(
              value: checked,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    checked = value;
                  }
                });
                widget.onCheckChanged?.call(value);
              }),
        ),
        Text(widget.label, style: const TextStyle(fontSize: 10.0)),
      ],
    );
  }
}
