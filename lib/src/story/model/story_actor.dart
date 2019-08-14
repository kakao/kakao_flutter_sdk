import 'package:json_annotation/json_annotation.dart';

part 'story_actor.g.dart';

/// Story
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StoryActor {
  /// <nodoc>
  StoryActor(this.displayName, this.profileThumbnailUrl);
  final String displayName;
  final Uri profileThumbnailUrl;

  /// <nodoc>
  factory StoryActor.fromJson(Map<String, dynamic> json) =>
      _$StoryActorFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryActorToJson(this);
}
