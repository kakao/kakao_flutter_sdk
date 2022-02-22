import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_link/src/constants.dart';
import 'package:kakao_flutter_sdk_link/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_link/src/model/link_result.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

/// Kakao SDK의 카카오링크 내부 동작에 사용되는 클라이언트
class LinkApi {
  LinkApi(this.dio);

  // DIO instance used by this class to make network requests.
  final Dio dio;

  static final LinkApi instance = LinkApi(ApiFactory.appKeyApi);

  /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오 링크 메시지로 공유
  Future<LinkResult> custom(int templateId,
      {Map<String, String>? templateArgs}) async {
    return _validate(Constants.validate, {
      Constants.templateId: templateId,
      Constants.templateArgs:
          templateArgs == null ? null : jsonEncode(templateArgs)
    });
  }

  /// 기본 템플릿을 카카오 링크 메시지로 공유
  Future<LinkResult> defaultTemplate(DefaultTemplate template) async {
    return _validate(Constants.defaultTemplate,
        {Constants.templateObject: jsonEncode(template)});
  }

  /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오 링크 메시지로 공유
  Future<LinkResult> scrap(String url,
      {int? templateId, Map<String, String>? templateArgs}) async {
    var params = {
      Constants.requestUrl: url,
      Constants.templateId: templateId,
      Constants.templateArgs:
          templateArgs == null ? null : jsonEncode(templateArgs)
    };
    params.removeWhere((k, v) => v == null);
    return _validate(Constants.scrap, params);
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 로컬 이미지를 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> uploadImage(File image,
      {bool secureResource = true}) {
    return ApiFactory.handleApiError(() async {
      var formData = FormData();
      var file = await MultipartFile.fromFile(image.path,
          filename: image.path.split("/").last);
      formData.files.add(MapEntry(Constants.file, file));
      formData.fields
          .add(MapEntry(Constants.secureResource, secureResource.toString()));
      Response response =
          await dio.post(Constants.uploadImagePath, data: formData);
      return ImageUploadResult.fromJson(response.data);
    });
  }

  /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> scrapImage(String imageUrl,
      {bool secureResource = true}) {
    return ApiFactory.handleApiError(() async {
      Response response = await dio.post(Constants.scrapImagePath, data: {
        Constants.imageUrl: imageUrl,
        Constants.secureResource: secureResource
      });
      return ImageUploadResult.fromJson(response.data);
    });
  }

  Future<LinkResult> _validate(String postfix, Map<String, dynamic> data) {
    return ApiFactory.handleApiError(() async {
      Response res = await dio.get("${Constants.validatePath}/$postfix",
          queryParameters: {
            Constants.linkVersion: Constants.linkVersion_40,
            ...data
          });
      return LinkResult.fromJson(res.data);
    });
  }
}
