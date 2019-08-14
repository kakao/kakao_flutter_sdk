import 'package:json_annotation/json_annotation.dart';

part 'link_info.g.dart';

/// Response from [StoryApi.scrapLink()], which is used as an input to [StoryApi.postLink()].
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class LinkInfo {
  /// <nodoc>
  LinkInfo(this.url, this.requestedUrl, this.host, this.title, this.images,
      this.description, this.section, this.type);

  /// Scraped url, possibly shortened.
  final Uri url;

  /// Original url.
  final Uri requestedUrl;

  /// Host of the requested url.
  final String host;

  /// Webpage title.
  final String title;

  /// image urls of . Maximum of 3.
  @JsonKey(name: "image")
  final List<String> images;

  /// Webpage description.
  final String description;

  /// Section information of the web page.
  final String section;

  /// Content type of the web page, such as website, video, music, etc.
  final String type;

  /// <nodoc>
  factory LinkInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LinkInfoToJson(this);
}
