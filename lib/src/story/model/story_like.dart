import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_actor.dart';

part 'story_like.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryLike {
  @JsonKey(unknownEnumValue: Emotion.UNKNOWN)
  final Emotion emotion;
  final StoryActor actor;

  /// <nodoc>
  StoryLike(this.emotion, this.actor);

  /// <nodoc>
  factory StoryLike.fromJson(Map<String, dynamic> json) =>
      _$StoryLikeFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryLikeToJson(this);
}

enum Emotion { LIKE, COOL, HAPPY, SAD, CHEER_UP, UNKNOWN }
