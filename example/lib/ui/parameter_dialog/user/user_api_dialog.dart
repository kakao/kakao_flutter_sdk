import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/text_field_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/parameter_dialog.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/user/user_api_methods.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/user/user_api_parameter.dart';

class UserApiDialog extends StatelessWidget {
  final String title;

  final bool propertiesVisibility;
  final bool resultVisibility;
  final bool tagsVisibility;
  final bool serviceTermsVisibility;
  final bool scopesVisibility;
  final Map<String, Object> result = {};

  UserApiDialog(this.title, {super.key})
      : propertiesVisibility = me == title,
        resultVisibility = serviceTerms == title,
        tagsVisibility = serviceTerms == title,
        serviceTermsVisibility = revokeServiceTerms == title,
        scopesVisibility = {scopes, revokeScopes}.contains(title);

  @override
  Widget build(BuildContext context) {
    return ParameterDialog(
      title: title,
      callback: (parameters) => _parameterResult(),
      items: [
        TextFieldItem(
          visible: propertiesVisibility,
          title: 'propertyKeys',
          hintText: "separate string by ','",
          fontSize: 10.0,
          onValueChanged: (value) => result['propertyKeys'] = value,
        ),
        TextFieldItem(
          visible: resultVisibility,
          title: 'result',
          hintText: "app_service_terms",
          editable: false,
          fontSize: 12.0,
        ),
        TextFieldItem(
          visible: tagsVisibility,
          title: 'tags',
          hintText: "separate string by ','",
          editable: false,
          fontSize: 12.0,
          onValueChanged: (value) => result['tags'] = value,
        ),
        TextFieldItem(
          visible: serviceTermsVisibility,
          title: 'serviceTerms',
          hintText: "separate string by ','",
          fontSize: 10.0,
          onValueChanged: (value) => result['serviceTerms'] = value,
        ),
        TextFieldItem(
          visible: scopesVisibility,
          title: 'scopes',
          hintText: "separate string by ','",
          fontSize: 12.0,
          onValueChanged: (value) => result['scopes'] = value,
        ),
      ],
    );
  }

  UserApiParameter _parameterResult() {
    return UserApiParameter(
      properties: (result['properties'] as String?)?.split(',') ?? [],
      result: result['result'] as String?,
      tags: (result['tags'] as String?)?.split(',') ?? [],
      serviceTerms: (result['serviceTerms'] as String?)?.split(',') ?? [],
      scopes: (result['scopes'] as String?)?.split(',') ?? [],
    );
  }
}
