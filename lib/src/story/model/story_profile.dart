import 'package:json_annotation/json_annotation.dart';

part 'story_profile.g.dart';

@JsonSerializable(includeIfNull: false)
class StoryProfile {
  /// <nodoc>
  StoryProfile(this.nickname, this.profileImageUrl, this.thumbnailUrl,
      this.permalink, this.birthday, this.birthdayType);
  @JsonKey(name: "nickName")
  String nickname;
  @JsonKey(name: "profileImageURL")
  Uri profileImageUrl;
  @JsonKey(name: "thumbnailURL")
  Uri thumbnailUrl;
  Uri permalink;
  String birthday;
  String birthdayType;

  /// <nodoc>
  factory StoryProfile.fromJson(Map<String, dynamic> json) =>
      _$StoryProfileFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryProfileToJson(this);

  @override
  String toString() => toJson().toString();
}
