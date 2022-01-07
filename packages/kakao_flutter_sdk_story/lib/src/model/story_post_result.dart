import 'package:json_annotation/json_annotation.dart';

part 'story_post_result.g.dart';

/// @nodoc
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryPostResult {
  final String id;

  StoryPostResult(this.id);

  factory StoryPostResult.fromJson(Map<String, dynamic> json) =>
      _$StoryPostResultFromJson(json);

  Map<String, dynamic> toJson() => _$StoryPostResultToJson(this);

  @override
  String toString() => toJson().toString();
}
