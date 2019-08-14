import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'content.g.dart';

/// Represents content section of feed, location, and commerce type template.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Content {
  /// <nodoc>
  Content(this.title, this.imageUrl, this.link,
      {this.imageWidth, this.imageHeight});
  final String title;
  final Uri imageUrl;
  final Link link;
  final int imageWidth;
  final int imageHeight;

  /// <nodoc>
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
