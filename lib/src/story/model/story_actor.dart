import 'package:json_annotation/json_annotation.dart';

part 'story_actor.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StoryActor {
  StoryActor(this.displayName, this.profileThumbnailUrl);
  final String displayName;
  final String profileThumbnailUrl;

  factory StoryActor.fromJson(Map<String, dynamic> json) =>
      _$StoryActorFromJson(json);
  Map<String, dynamic> toJson() => _$StoryActorToJson(this);
}
