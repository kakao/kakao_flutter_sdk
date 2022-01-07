import 'package:json_annotation/json_annotation.dart';

part 'story_actor.g.dart';

/// 카카오스토리의 작성자 정보를 담고 있는 클래스
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StoryActor {
  final String displayName;
  final String? profileThumbnailUrl;

  /// @nodoc
  StoryActor(this.displayName, this.profileThumbnailUrl);

  /// @nodoc
  factory StoryActor.fromJson(Map<String, dynamic> json) =>
      _$StoryActorFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryActorToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
