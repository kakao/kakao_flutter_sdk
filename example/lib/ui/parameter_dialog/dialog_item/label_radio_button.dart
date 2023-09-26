import 'package:flutter/material.dart';

class LabelRadioButton<T> extends StatefulWidget {
  final String label;
  final T value;
  final T? groupValue;

  final ValueChanged<T?>? onChanged;

  const LabelRadioButton({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<LabelRadioButton<T>> createState() => _LabelRadioButtonState<T>();
}

class _LabelRadioButtonState<T> extends State<LabelRadioButton<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Radio(
            groupValue: widget.groupValue,
            value: widget.value,
            onChanged: (T? value) {
              widget.onChanged?.call(value);
            },
          ),
        ),
        Text(widget.label, style: const TextStyle(fontSize: 10.0)),
      ],
    );
  }
}
