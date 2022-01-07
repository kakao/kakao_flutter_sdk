import 'package:json_annotation/json_annotation.dart';

part 'story_image.g.dart';

/// 카카오스토리의 내스토리 정보 중 이미지 내용을 담고 있는 클래스
@JsonSerializable(includeIfNull: false)
class StoryImage {
  /// 1280 * 1706
  final String? xlarge;

  /// 720 * 960
  final String? large;

  /// 240 * 320
  final String? medium;

  /// 160 * 213
  final String? small;

  /// 원본 이미지의 url
  final String? original;

  /// @nodoc
  StoryImage(this.xlarge, this.large, this.medium, this.small, this.original);

  /// @nodoc
  factory StoryImage.fromJson(Map<String, dynamic> json) =>
      _$StoryImageFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryImageToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
