import 'package:json_annotation/json_annotation.dart';

part 'story_profile.g.dart';

@JsonSerializable(includeIfNull: false)
class StoryProfile {
  @JsonKey(name: "nickName")
  String? nickname;
  @JsonKey(name: "profileImageURL")
  String? profileImageUrl;
  @JsonKey(name: "thumbnailURL")
  String? thumbnailUrl;
  @JsonKey(name: "bgImageURL")
  String? bgImageUrl;
  String? permalink;
  String? birthday;
  String? birthdayType;

  /// <nodoc>
  StoryProfile(this.nickname, this.profileImageUrl, this.thumbnailUrl,
      this.bgImageUrl, this.permalink, this.birthday, this.birthdayType);

  /// <nodoc>
  factory StoryProfile.fromJson(Map<String, dynamic> json) =>
      _$StoryProfileFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$StoryProfileToJson(this);

  @override
  String toString() => toJson().toString();
}
