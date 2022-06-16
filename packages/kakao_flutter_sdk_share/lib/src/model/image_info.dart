import 'package:json_annotation/json_annotation.dart';

part 'image_info.g.dart';

/// 업로드된 개별 이미지 정보
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageInfo {
  /// 업로드 된 이미지의 URL
  final String url;

  /// 업로드 된 이미지의 Content-Type
  final String contentType;

  /// 업로드 된 이미지의 용량 (단위: 바이트)
  final int length;

  /// 업로드 된 이미지의 너비 (단위: 픽셀)
  final int width;

  /// 업로드 된 이미지의 높이 (단위: 픽셀)
  final int height;

  /// @nodoc
  ImageInfo(this.url, this.contentType, this.length, this.width, this.height);

  /// @nodoc
  factory ImageInfo.fromJson(Map<String, dynamic> json) =>
      _$ImageInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ImageInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
