import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

import 'constants.dart';
import 'model/image_upload_result.dart';
import 'model/sharing_result.dart';

/// @nodoc
class ShareApi {
  ShareApi(this._client);

  final KakaoHttpClient _client;

  Future<SharingResult> custom(
    int templateId, {
    Map<String, String>? templateArgs,
  }) {
    SdkLog.d(
      '[ShareApi.custom] started | templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0}',
    );
    final data = <String, Object>{
      Constants.templateId: templateId,
      Constants.templateArgs: ?templateArgs?.toJson(),
    };

    return _validate(Constants.validate, data);
  }

  Future<SharingResult> defaultTemplate(DefaultTemplate template) async {
    SdkLog.d(
      '[ShareApi.defaultTemplate] started | templateType=${template.runtimeType}',
    );
    final data = <String, String>{
      Constants.templateObject: jsonEncode(template),
    };

    return _validate(Constants.defaultTemplate, data);
  }

  Future<SharingResult> scrap(
    String url, {
    int? templateId,
    Map<String, String>? templateArgs,
  }) async {
    SdkLog.d(
      '[ShareApi.scrap] started | url=$url templateId=$templateId templateArgsCount=${templateArgs?.length ?? 0}',
    );
    final data = <String, Object>{
      Constants.requestUrl: url,
      Constants.templateId: ?templateId,
      Constants.templateArgs: ?templateArgs?.toJson(),
    };

    return _validate(Constants.scrap, data);
  }

  Future<ImageUploadResult> uploadImage(
    String? imagePath,
    Uint8List? byteData,
    bool secureResource,
  ) async {
    assert(imagePath != null || byteData != null);
    SdkLog.d(
      '[ShareApi.uploadImage] started | source=${imagePath != null ? 'file' : 'bytes'} secureResource=$secureResource',
    );

    final MultipartFile file;

    if (imagePath != null) {
      file = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
    } else {
      file = MultipartFile.fromBytes(byteData!, filename: 'image');
    }

    final formData = FormData()
      ..files.add(MapEntry(Constants.file, file))
      ..fields.add(
        MapEntry(Constants.secureResource, secureResource.toString()),
      );

    final response = await _client.post(
      Constants.uploadImagePath,
      data: formData,
    );
    final result = ImageUploadResult.fromJson(response.data);
    SdkLog.i(
      '[ShareApi.uploadImage] completed | infoCount=${result.infos.original.length}',
    );
    return result;
  }

  Future<ImageUploadResult> scrapImage(
    String imageUrl,
    bool secureResource,
  ) async {
    SdkLog.d(
      '[ShareApi.scrapImage] started | imageUrl=$imageUrl secureResource=$secureResource',
    );
    final response = await _client.post(
      Constants.scrapImagePath,
      data: {
        Constants.imageUrl: imageUrl,
        Constants.secureResource: secureResource.toString(),
      },
    );
    final result = ImageUploadResult.fromJson(response.data);
    SdkLog.i(
      '[ShareApi.scrapImage] completed | infoCount=${result.infos.original.length}',
    );
    return result;
  }

  Future<SharingResult> _validate(
    String postfix,
    Map<String, Object> data,
  ) async {
    SdkLog.v('[ShareApi.validate] started | postfix=$postfix');
    final queryParams = <String, Object>{
      Constants.linkVersion: Constants.linkVersion_40,
      ...data,
    };
    final response = await _client.get(
      '${Constants.validatePath}/$postfix',
      queryParameters: queryParams,
    );
    final result = SharingResult.fromJson(response.data);
    SdkLog.i(
      '[ShareApi.validate] completed | templateId=${result.templateId} schemeParamKeys=${result.schemeParams?.keys.join(',')}',
    );
    return result;
  }
}
