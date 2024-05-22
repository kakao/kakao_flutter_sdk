import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/checkbox_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/text_field_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/login/login_methods.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/login/login_parameter.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/parameter_dialog.dart';

class LoginDialog extends StatelessWidget {
  final String title;

  final bool promptsVisibility;
  final bool loginHintVisibility;
  final bool scopesVisibility;
  final bool nonceVisibility;
  final bool channelPublicIdsVisibility;
  final bool serviceTermsVisibility;
  final Map<String, Object> result = {};

  LoginDialog(this.title, {super.key})
      : promptsVisibility = {accountLogin}.contains(title),
        loginHintVisibility = {accountLogin}.contains(title),
        scopesVisibility = title == newScopes,
        nonceVisibility = true,
        channelPublicIdsVisibility = title != newScopes,
        serviceTermsVisibility = title != newScopes;

  @override
  Widget build(BuildContext context) {
    return ParameterDialog(
      title: title,
      callback: (parameters) => _parameterResult(),
      items: [
        CheckboxItem<Prompt>(
            visible: promptsVisibility,
            title: 'prompts',
            fontSize: 12.0,
            items: const [Prompt.login, Prompt.create, Prompt.selectAccount],
            onValueChanged: (value) => result['prompts'] = value),
        TextFieldItem(
            visible: loginHintVisibility,
            title: 'loginHint',
            hintText: 'write login hint here',
            fontSize: 12.0,
            onValueChanged: (value) => result['loginHint'] = value),
        TextFieldItem(
            visible: scopesVisibility,
            title: 'scopes',
            hintText: "separate string by ','",
            fontSize: 12.0,
            onValueChanged: (value) => result['scopes'] = value),
        TextFieldItem(
            visible: nonceVisibility,
            title: 'nonce',
            hintText: "write nonce here",
            fontSize: 12.0,
            onValueChanged: (value) => result['nonce'] = value),
        TextFieldItem(
            visible: channelPublicIdsVisibility,
            title: 'channelPublicIds',
            hintText: "separate string by ','",
            fontSize: 8.0,
            onValueChanged: (value) => result['channelPublicIds'] = value),
        TextFieldItem(
            visible: serviceTermsVisibility,
            title: 'serviceTerms',
            hintText: "separate string by ','",
            fontSize: 10.0,
            onValueChanged: (value) => result['serviceTerms'] = value),
      ],
    );
  }

  LoginParameter _parameterResult() {
    return LoginParameter(
      prompts: (result['prompts'] as List<Prompt>?) ?? [],
      loginHint: result['loginHint'] as String?,
      scopes: (result['scopes'] as String?)?.split(',') ?? [],
      nonce: result['nonce'] as String?,
      channelPublicIds:
          (result['channelPublicIds'] as String?)?.split(',') ?? [],
      serviceTerms: (result['serviceTerms'] as String?)?.split(',') ?? [],
    );
  }
}
