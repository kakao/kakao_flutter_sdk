import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/link/model/image_infos.dart';

part 'image_upload_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageUploadResult {
  final ImageInfos infos;

  /// <nodoc>
  ImageUploadResult(this.infos);

  /// <nodoc>
  factory ImageUploadResult.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResultFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ImageUploadResultToJson(this);
}
