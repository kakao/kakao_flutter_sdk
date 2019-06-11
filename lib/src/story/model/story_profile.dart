import 'package:json_annotation/json_annotation.dart';

part 'story_profile.g.dart';

@JsonSerializable()
class StoryProfile {
  StoryProfile(this.nickname, this.profileImageUrl, this.thumbnailUrl,
      this.permalink, this.birthday, this.birthdayType);
  @JsonKey(name: "nickName")
  String nickname;
  @JsonKey(name: "profileImageURL")
  String profileImageUrl;
  @JsonKey(name: "thumbnailURL")
  String thumbnailUrl;
  String permalink;
  String birthday;
  String birthdayType;

  factory StoryProfile.fromJson(Map<String, dynamic> json) =>
      _$StoryProfileFromJson(json);
  Map<String, dynamic> toJson() => _$StoryProfileToJson(this);
}
