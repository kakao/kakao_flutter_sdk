import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/link/model/image_info.dart';

part 'image_infos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageInfos {
  final ImageInfo original;

  /// <nodoc>
  ImageInfos(this.original);

  /// <nodoc>
  factory ImageInfos.fromJson(Map<String, dynamic> json) =>
      _$ImageInfosFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ImageInfosToJson(this);
}
