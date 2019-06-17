import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/api_factory.dart';
import 'package:kakao_flutter_sdk/src/link/model/link_response.dart';

class LinkApi {
  LinkApi(this.dio);
  final Dio dio;
  static final LinkApi instance = LinkApi(ApiFactory.appKeyApi);
  Future<LinkResponse> custom(
      int templateId, Map<String, String> templateArgs) async {
    return ApiFactory.handleApiError(() async {
      Response res = await dio
          .get("/v2/api/kakaolink/talk/template/validate", queryParameters: {
        "link_ver": "4.0",
        "template_id": templateId,
        "template_args": jsonEncode(templateArgs)
      });
      return LinkResponse.fromJson(res.data);
    });
  }
}
