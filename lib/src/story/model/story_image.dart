import 'package:json_annotation/json_annotation.dart';

part 'story_image.g.dart';

@JsonSerializable(includeIfNull: false)
class StoryImage {
  /// <nodoc>
  StoryImage(this.xlarge, this.large, this.medium, this.small, this.original);
  final String xlarge;
  final String large;
  final String medium;
  final String small;
  final String original;

  /// <nodoc>
  factory StoryImage.fromJson(Map<String, dynamic> json) =>
      _$StoryImageFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryImageToJson(this);
}
