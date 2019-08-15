import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/story/model/story_actor.dart';

part 'story_like.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryLike {
  /// <nodoc>
  StoryLike(this.emoticon, this.actor);
  @JsonKey(unknownEnumValue: Emoticon.UNKNOWN)
  final Emoticon emoticon;
  final StoryActor actor;

  /// <nodoc>
  factory StoryLike.fromJson(Map<String, dynamic> json) =>
      _$StoryLikeFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryLikeToJson(this);
}

enum Emoticon { LIKE, COOL, HAPPY, SAD, CHEER_UP, UNKNOWN }
