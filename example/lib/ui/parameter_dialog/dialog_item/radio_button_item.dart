import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/label_radio_button.dart';

class RadioButtonItem<T> extends StatefulWidget {
  final String title;
  final double fontSize;
  final ValueChanged<T?> onValueChanged;
  final bool visible;
  final bool switchChecked;
  final List<T> items;
  late final check = List.filled(items.length, false);

  RadioButtonItem({
    required this.title,
    required this.fontSize,
    required this.onValueChanged,
    required this.items,
    this.switchChecked = false,
    this.visible = true,
    super.key,
  });

  @override
  State<RadioButtonItem<T>> createState() => _RadioButtonItemState<T>();
}

class _RadioButtonItemState<T> extends State<RadioButtonItem<T>> {
  late var _isChecked = widget.switchChecked;
  late T? _groupValue = widget.items[0];

  @override
  Widget build(BuildContext context) {
    var items = widget.items.map((item) {
      var label = (item is Enum) ? item.name : item.toString();
      return LabelRadioButton<T>(
        label: label,
        value: item,
        groupValue: _groupValue,
        onChanged: (T? value) {
          setState(() {
            _groupValue = value;
          });
          widget.onValueChanged.call(_groupValue);
        },
      );
    });
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
                  widget.onValueChanged(_groupValue);
                }
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 1,
            child: Text(
              widget.title,
              style: TextStyle(fontSize: widget.fontSize),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: items.toList()),
            ),
          ),
        ],
      ),
    );
  }
}
