import 'package:json_annotation/json_annotation.dart';

part 'link_info.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class LinkInfo {
  LinkInfo(this.url, this.requestedUrl, this.host, this.title, this.images,
      this.description, this.section, this.type);
  final String url;
  final String requestedUrl;
  final String host;
  final String title;
  @JsonKey(name: "image")
  final String images;
  final String description;
  final String section;
  final String type;

  factory LinkInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LinkInfoToJson(this);
}
