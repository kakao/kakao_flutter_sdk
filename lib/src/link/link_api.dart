import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/link/model/link_response.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';

class LinkApi {
  LinkApi(this.dio);
  final Dio dio;
  static final LinkApi instance = LinkApi(ApiFactory.appKeyApi);

  Future<LinkResponse> custom(int templateId,
      {Map<String, String> templateArgs}) async {
    return _validate("validate", {
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    });
  }

  Future<LinkResponse> defaultTemplate(DefaultTemplate template) async {
    return _validate("default", {"template_object": jsonEncode(template)});
  }

  Future<LinkResponse> scrap(String url,
      {int templateId, Map<String, String> templateArgs}) async {
    var params = {
      "request_url": url,
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    params.removeWhere((k, v) => v == null);
    return _validate("scrap", params);
  }

  Future<LinkResponse> _validate(String postfix, Map<String, dynamic> data) {
    return ApiFactory.handleApiError(() async {
      Response res = await dio.get("/v2/api/kakaolink/talk/template/$postfix",
          queryParameters: {"link_ver": "4.0", ...data});
      return LinkResponse.fromJson(res.data);
    });
  }
}
