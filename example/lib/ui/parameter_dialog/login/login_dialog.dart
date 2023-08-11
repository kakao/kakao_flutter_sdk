import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/checkbox_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/text_field_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/login/login_methods.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/login/login_parameter.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/parameter_dialog.dart';

class LoginDialog extends StatelessWidget {
  final String title;
  final String settleId;

  final bool promptsVisibility;
  final bool loginHintVisibility;
  final bool scopesVisibility;
  final bool stateVisibility;
  final bool nonceVisibility;
  final bool channelPublicIdsVisibility;
  final bool serviceTermsVisibility;
  final bool settleIdVisibility;
  final Map<String, Object> result = {};

  LoginDialog(this.title, {this.settleId = '', super.key})
      : promptsVisibility =
            {accountLogin, talkCertLogin, accountCertLogin}.contains(title),
        loginHintVisibility = {accountLogin, accountCertLogin}.contains(title),
        scopesVisibility = title == newScopes,
        stateVisibility = {talkCertLogin, accountCertLogin}.contains(title),
        nonceVisibility = true,
        channelPublicIdsVisibility = title != newScopes,
        serviceTermsVisibility = title != newScopes,
        settleIdVisibility = {talkCertLogin, accountCertLogin}.contains(title);

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
            visible: stateVisibility,
            title: 'state',
            hintText: "write state here",
            fontSize: 12.0,
            onValueChanged: (value) => result['state'] = value),
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
        TextFieldItem(
            switchChecked: true,
            visible: settleIdVisibility,
            title: 'settleId',
            hintText: settleId,
            editable: false,
            fontSize: 12.0),
      ],
    );
  }

  LoginParameter _parameterResult() {
    return LoginParameter(
      prompts: (result['prompts'] as List<Prompt>?) ?? [],
      loginHint: result['loginHint'] as String?,
      scopes: (result['scopes'] as String?)?.split(',') ?? [],
      state: result['state'] as String?,
      nonce: result['nonce'] as String?,
      settleId: result['settleId'] as String?,
      channelPublicIds:
          (result['channelPublicIds'] as String?)?.split(',') ?? [],
      serviceTerms: (result['serviceTerms'] as String?)?.split(',') ?? [],
    );
  }
}
