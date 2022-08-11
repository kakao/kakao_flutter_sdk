import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_share/src/constants.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_upload_result.dart';
import 'package:kakao_flutter_sdk_share/src/model/sharing_result.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

/// Kakao SDK의 카카오톡 공유 내부 동작에 사용되는 클라이언트
class ShareApi {
  ShareApi(this.dio);

  // DIO instance used by this class to make network requests.
  final Dio dio;

  static final ShareApi instance = ShareApi(ApiFactory.appKeyApi);

  /// 카카오디벨로퍼스에서 생성한 메시지 템플릿을 카카오톡 메시지로 공유
  Future<SharingResult> custom(int templateId,
      {Map<String, String>? templateArgs}) async {
    return _validate(Constants.validate, {
      Constants.templateId: templateId,
      Constants.templateArgs:
          templateArgs == null ? null : jsonEncode(templateArgs)
    });
  }

  /// 기본 템플릿을 카카오톡 메시지로 공유
  Future<SharingResult> defaultTemplate(DefaultTemplate template) async {
    return _validate(Constants.defaultTemplate,
        {Constants.templateObject: jsonEncode(template)});
  }

  /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오톡 메시지로 공유
  Future<SharingResult> scrap(String url,
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

  /// 로컬 이미지를 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 카카오 이미지 서버로 업로드
  Future<ImageUploadResult> uploadImage(File? image, Uint8List? byteData,
      {bool secureResource = true}) async {
    return ApiFactory.handleApiError(() async {
      var formData = FormData();

      final MultipartFile file;

      if (image != null) {
        file = await MultipartFile.fromFile(image.path,
            filename: image.path.split("/").last);
      } else {
        file = MultipartFile.fromBytes(byteData!, filename: "image");
      }
      formData.files.add(MapEntry(Constants.file, file));
      formData.fields
          .add(MapEntry(Constants.secureResource, secureResource.toString()));
      Response response =
          await dio.post(Constants.uploadImagePath, data: formData);
      return ImageUploadResult.fromJson(response.data);
    });
  }

  /// 원격 이미지를 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 카카오 이미지 서버로 업로드
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

  Future<SharingResult> _validate(String postfix, Map<String, dynamic> data) {
    return ApiFactory.handleApiError(() async {
      Response res = await dio.get("${Constants.validatePath}/$postfix",
          queryParameters: {
            Constants.linkVersion: Constants.linkVersion_40,
            ...data
          });
      return SharingResult.fromJson(res.data);
    });
  }
}
