import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_infos.dart';

part 'image_upload_result.g.dart';

/// KO: 이미지 업로드 결과
/// <br>
/// EN: Image upload result
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageUploadResult {
  /// KO: 이미지 정보 목록
  /// <br>
  /// EN: List of image information
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
