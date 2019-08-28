import 'package:json_annotation/json_annotation.dart';

part 'image_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImageResult {
  String collection;
  Uri thumbnailUrl;
  Uri imageUrl;
  int width;
  int height;
  String displaySitename;
  Uri docUrl;
  DateTime datetime;

  ImageResult(this.collection, this.thumbnailUrl, this.imageUrl, this.width,
      this.height, this.displaySitename, this.docUrl, this.datetime);

  /// <nodoc>
  factory ImageResult.fromJson(Map<String, dynamic> json) =>
      _$ImageResultFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ImageResultToJson(this);

  @override
  String toString() => toJson().toString();
}
