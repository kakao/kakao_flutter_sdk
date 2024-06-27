import 'package:json_annotation/json_annotation.dart';

part 'image_info.g.dart';

/// KO: 이미지 정보
/// <br>
/// EN: Image information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageInfo {
  /// KO: 이미지 URL
  /// <br>
  /// EN: Image URL
  final String url;

  /// KO: 이미지 포맷
  /// <br>
  /// EN: Image format
  final String contentType;

  /// KO: 이미지 파일 크기
  /// <br>
  /// EN: Image file size
  final int length;

  /// KO: 이미지 너비
  /// <br>
  /// EN: Image width
  final int width;

  /// KO: 이미지 높이
  /// <br>
  /// EN: Image height
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
