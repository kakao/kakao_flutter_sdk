import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_actor.dart';

part 'story_like.g.dart';

/// 카카오스토리의 좋아요 등 느낌(감정표현)에 대한 정보를 담고 있는 클래스
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryLike {
  @JsonKey(unknownEnumValue: Emotion.UNKNOWN)
  final Emotion emotion;
  final StoryActor actor;

  /// @nodoc
  StoryLike(this.emotion, this.actor);

  /// @nodoc
  factory StoryLike.fromJson(Map<String, dynamic> json) =>
      _$StoryLikeFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryLikeToJson(this);
}

enum Emotion { LIKE, COOL, HAPPY, SAD, CHEER_UP, UNKNOWN }
