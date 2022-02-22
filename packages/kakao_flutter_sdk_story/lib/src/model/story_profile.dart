import 'package:json_annotation/json_annotation.dart';

part 'story_profile.g.dart';

/// 카카오스토리 프로필 조회 API 응답 클래스
@JsonSerializable(includeIfNull: false)
class StoryProfile {
  /// 카카오스토리 닉네임
  @JsonKey(name: "nickName")
  String? nickname;

  /// 카카오스토리 프로필 이미지 URL
  @JsonKey(name: "profileImageURL")
  String? profileImageUrl;

  /// 카카오스토리 프로필 이미지 썸네일 URL
  @JsonKey(name: "thumbnailURL")
  String? thumbnailUrl;

  /// 카카오스토리 배경이미지 URL
  @JsonKey(name: "bgImageURL")
  String? bgImageUrl;

  /// 카카오스토리 permanent link
  /// 내 스토리를 방문할 수 있는 웹 page 의 URL
  String? permalink;
  String? birthday;
  String? birthdayType;

  /// @nodoc
  StoryProfile(this.nickname, this.profileImageUrl, this.thumbnailUrl,
      this.bgImageUrl, this.permalink, this.birthday, this.birthdayType);

  /// @nodoc
  factory StoryProfile.fromJson(Map<String, dynamic> json) =>
      _$StoryProfileFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$StoryProfileToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
