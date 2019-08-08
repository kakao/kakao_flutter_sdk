import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/template/model/link.dart';

part 'content.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Content {
  Content(this.title, this.imageUrl, this.link,
      {this.imageWidth, this.imageHeight});
  final String title;
  final String imageUrl;
  final Link link;
  final int imageWidth;
  final int imageHeight;
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
