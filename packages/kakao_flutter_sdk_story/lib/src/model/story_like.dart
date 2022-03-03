import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_actor.dart';

part 'story_like.g.dart';

/// 카카오스토리의 좋아요 등 느낌(감정표현)에 대한 정보를 담고 있는 클래스
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StoryLike {
  @JsonKey(unknownEnumValue: Emotion.unknown)
  final Emotion emotion;
  final StoryActor actor;

  /// @nodoc
  StoryLike(this.emotion, this.actor);

  /// @nodoc
  factory StoryLike.fromJson(Map<String, dynamic> json) =>
      _$StoryLikeFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryLikeToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// 느낌(이모티콘)에 대한 정의
enum Emotion {
  /// 좋아요
  @JsonValue("LIKE")
  like,

  /// 멋져요
  @JsonValue("COOL")
  cool,

  /// 기뻐요
  @JsonValue("HAPPY")
  happy,

  /// 슬퍼요
  @JsonValue("SAD")
  sad,

  /// 힘내요
  @JsonValue("CHEER_UP")
  cheerUp,

  /// 정의되지 않은 느낌
  @JsonValue("UNKNOWN")
  unknown
}
