import 'package:json_annotation/json_annotation.dart';

part 'story_image.g.dart';

@JsonSerializable(includeIfNull: false)
class StoryImage {
  StoryImage(this.xlarge, this.large, this.medium, this.small, this.original);
  final String xlarge;
  final String large;
  final String medium;
  final String small;
  final String original;

  factory StoryImage.fromJson(Map<String, dynamic> json) =>
      _$StoryImageFromJson(json);
  Map<String, dynamic> toJson() => _$StoryImageToJson(this);
}
