import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/radio_button_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/text_field_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/parameter_dialog.dart';

class ShareApiDialog extends StatelessWidget {
  final String title;

  final Map<String, dynamic> result = {};

  ShareApiDialog(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    result['template_id'] = 4583;
    return ParameterDialog(
      title: title,
      callback: (parameters) => result,
      items: [
        TextFieldItem(
          visible: true,
          title: 'templateId',
          fontSize: 12.0,
          onValueChanged: (value) => result['template_id'] = int.parse(value),
          keyboardType: TextInputType.number,
          switchChecked: true,
          text: '4583',
        ),
        RadioButtonItem(
            title: 'ShareType',
            fontSize: 12.0,
            onValueChanged: (value) => result['shareType'] = value,
            items: ShareType.values),
        TextFieldItem(
          visible: true,
          title: 'limit',
          fontSize: 12.0,
          onValueChanged: (value) => result['limit'] = int.parse(value),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
