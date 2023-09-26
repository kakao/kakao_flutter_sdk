import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/label_chckbox.dart';

class CheckboxItem<T> extends StatefulWidget {
  final String title;
  final double fontSize;
  final ValueChanged<List<T>> onValueChanged;
  final bool visible;
  final bool switchChecked;
  final List<T> items;
  late final check = List.filled(items.length, false);
  final List<T> selected = [];

  CheckboxItem({
    required this.title,
    required this.fontSize,
    required this.onValueChanged,
    required this.items,
    this.switchChecked = false,
    this.visible = true,
    super.key,
  });

  @override
  State<CheckboxItem> createState() => _CheckboxItemState<T>();
}

class _CheckboxItemState<T> extends State<CheckboxItem<T>> {
  late var _isChecked = widget.switchChecked;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (int i = 0; i < widget.items.length; i++) {
      var item = widget.items[i];
      var label = (item is Enum) ? item.name : item.toString();

      items.add(
        LabelCheckbox(
          label: label,
          onCheckChanged: (value) {
            if (value == null) return;

            widget.check[i] = value;

            if (widget.check[i]) {
              widget.selected.add(widget.items[i]);
            } else {
              widget.selected.remove(widget.items[i]);
            }

            widget.onValueChanged(widget.selected);

            setState(() =>
                _isChecked = widget.check.any((element) => element == true));
          },
        ),
      );
    }
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
                  widget.onValueChanged(widget.selected);
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
              child: Row(children: items),
            ),
          ),
        ],
      ),
    );
  }
}
