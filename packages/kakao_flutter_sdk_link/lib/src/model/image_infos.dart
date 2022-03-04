import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_link/src/model/image_info.dart';

part 'image_infos.g.dart';

/// 업로드된 이미지 정보
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
