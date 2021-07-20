import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/src/common/api_factory.dart';
import 'package:kakao_flutter_sdk/src/link/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk/src/link/model/link_result.dart';
import 'package:kakao_flutter_sdk/src/template/default_template.dart';

///
class LinkApi {
  LinkApi(this.dio);

  // DIO instance used by this class to make network requests.
  final Dio dio;

  /// singleton instance of this class.
  static final LinkApi instance = LinkApi(ApiFactory.appKeyApi);

  /// Send KakaoLink messages with custom templates.
  /// This
  Future<LinkResult> custom(int templateId,
      {Map<String, String>? templateArgs}) async {
    return _validate("validate", {
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    });
  }

  /// Send KakaoLink messages with default templates.
  Future<LinkResult> defaultTemplate(DefaultTemplate template) async {
    return _validate("default", {"template_object": jsonEncode(template)});
  }

  /// Send kakaoLink messages with scrapped url.
  Future<LinkResult> scrap(String url,
      {int? templateId, Map<String, String>? templateArgs}) async {
    var params = {
      "request_url": url,
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    };
    params.removeWhere((k, v) => v == null);
    return _validate("scrap", params);
  }

  /// Upload the local image to the Kakao Image Server to use it as a KakaoLink content image.
  Future<ImageUploadResult> uploadImage(File image,
      {bool secureResource = true}) {
    return ApiFactory.handleApiError(() async {
      var formData = FormData();
      var file = await MultipartFile.fromFile(image.path,
          filename: image.path.split("/").last);
      formData.files.add(MapEntry('file', file));
      formData.fields
          .add(MapEntry('secure_resource', secureResource.toString()));
      Response response =
          await dio.post('/v2/api/talk/message/image/upload', data: formData);
      return ImageUploadResult.fromJson(response.data);
    });
  }

  /// Upload remote image to Kakao Image Server to use as KakaoLink content image.
  Future<ImageUploadResult> scrapImage(String imageUrl,
      {bool secureResource = true}) {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.post('/v2/api/talk/message/image/scrap',
          data: {'image_url': imageUrl, 'secure_resource': secureResource});
      return ImageUploadResult.fromJson(response.data);
    });
  }

  Future<LinkResult> _validate(String postfix, Map<String, dynamic> data) {
    return ApiFactory.handleApiError(() async {
      Response res = await dio.get("/v2/api/kakaolink/talk/template/$postfix",
          queryParameters: {"link_ver": "4.0", ...data});
      return LinkResult.fromJson(res.data);
    });
  }
}
