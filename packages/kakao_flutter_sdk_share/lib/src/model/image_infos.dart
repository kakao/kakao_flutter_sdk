import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_share/src/model/image_info.dart';

part 'image_infos.g.dart';

/// KO: 이미지 정보 목록
/// <br>
/// EN: List of image information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageInfos {
  /// 원본 이미지
  final ImageInfo original;

  /// @nodoc
  ImageInfos(this.original);

  /// @nodoc
  factory ImageInfos.fromJson(Map<String, dynamic> json) =>
      _$ImageInfosFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ImageInfosToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
