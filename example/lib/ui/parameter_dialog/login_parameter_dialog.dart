import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/login_methods.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/login_parameter_result.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/prompts_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/text_field_item.dart';

class LoginParameterDialog extends StatelessWidget {
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

  LoginParameterDialog(this.title, {this.settleId = '', super.key})
      : promptsVisibility = {accountLogin, talkCertLogin, accountCertLogin}.contains(title),
        loginHintVisibility = {accountLogin, accountCertLogin}.contains(title),
        scopesVisibility = title == newScopes,
        stateVisibility = {talkCertLogin, accountCertLogin}.contains(title),
        nonceVisibility = true,
        channelPublicIdsVisibility = title != newScopes,
        serviceTermsVisibility = title != newScopes,
        settleIdVisibility = {talkCertLogin, accountCertLogin}.contains(title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Center(child: Text(title)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxItem(
                  visible: promptsVisibility,
                  title: 'prompts',
                  fontSize: 12.0,
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
                  hintText: "seperate string by ','",
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
                  editing: false,
                  fontSize: 12.0,
                  onValueChanged: (value) => result['settleId'] = value),
              actions(context),
            ],
          ),
        ),
      ),
      insetPadding: const EdgeInsets.all(16.0),
      titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      contentPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
    );
  }

  Widget actions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: actionButton(
              'Close',
              () => Navigator.of(context).pop(),
              backgroundColor: Colors.grey,
            ),
          ),
          Expanded(
            flex: 3,
            child: actionButton(
              'Request',
              () => Navigator.of(context).pop(_parameterResult()),
              backgroundColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  ParameterResult _parameterResult() {
    return ParameterResult(
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

  Widget actionButton(String text, VoidCallback onPressed,
      {Color? backgroundColor, int? flex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        child: Text(text),
      ),
    );
  }
}
