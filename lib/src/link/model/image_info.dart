import 'package:json_annotation/json_annotation.dart';

part 'image_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageInfo {
  final String url;
  final String contentType;
  final int length;
  final int width;
  final int height;

  /// <nodoc>
  ImageInfo(this.url, this.contentType, this.length, this.width, this.height);

  /// <nodoc>
  factory ImageInfo.fromJson(Map<String, dynamic> json) =>
      _$ImageInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ImageInfoToJson(this);
}
