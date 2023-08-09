import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/label_chckbox.dart';

class CheckboxItem extends StatefulWidget {
  final String title;
  final double fontSize;
  final ValueChanged<List<Prompt>> onValueChanged;
  final bool visible;
  final bool switchChecked;
  final prompts = [
    Prompt.login,
    Prompt.create,
    Prompt.selectAccount,
    Prompt.cert,
  ];
  late final check = List.filled(prompts.length, false);
  final List<Prompt> selected = [];

  CheckboxItem({
    required this.title,
    required this.fontSize,
    required this.onValueChanged,
    this.switchChecked = false,
    this.visible = true,
    super.key,
  });

  @override
  State<CheckboxItem> createState() => _CheckboxItemState();
}

class _CheckboxItemState extends State<CheckboxItem> {
  late var _isChecked = widget.switchChecked;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (int i = 0; i < widget.prompts.length; i++) {
      items.add(
        LabelCheckbox(
          label: widget.prompts[i].name,
          onCheckChanged: (value) {
            if (value == null) return;

            widget.check[i] = value;

            if (widget.check[i]) {
              widget.selected.add(widget.prompts[i]);
            } else {
              widget.selected.remove(widget.prompts[i]);
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
