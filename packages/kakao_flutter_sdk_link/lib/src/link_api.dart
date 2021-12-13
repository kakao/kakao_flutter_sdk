import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kakao_flutter_sdk_link/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_link/src/model/link_result.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

class LinkApi {
  LinkApi(this.dio);

  // DIO instance used by this class to make network requests.
  final Dio dio;

  static final LinkApi instance = LinkApi(ApiFactory.appKeyApi);

  /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오 링크 메시지로 공유.
  Future<LinkResult> custom(int templateId,
      {Map<String, String>? templateArgs}) async {
    return _validate("validate", {
      "template_id": templateId,
      "template_args": templateArgs == null ? null : jsonEncode(templateArgs)
    });
  }

  /// 기본 템플릿을 카카오 링크 메시지로 공유.
  Future<LinkResult> defaultTemplate(DefaultTemplate template) async {
    return _validate("default", {"template_object": jsonEncode(template)});
  }

  /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오 링크 메시지로 공유.
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

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 로컬 이미지를 카카오 이미지 서버로 업로드.
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

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드.
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
