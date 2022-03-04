import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_link/src/model/image_infos.dart';

part 'image_upload_result.g.dart';

/// 이미지 업로드,스크랩 요청 결과
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageUploadResult {
  /// 업로드된 이미지 정보
  final ImageInfos infos;

  /// @nodoc
  ImageUploadResult(this.infos);

  /// @nodoc
  factory ImageUploadResult.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResultFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ImageUploadResultToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
