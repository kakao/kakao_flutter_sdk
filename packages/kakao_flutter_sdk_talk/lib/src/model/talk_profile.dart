import 'package:json_annotation/json_annotation.dart';

part 'talk_profile.g.dart';

/// 카카오톡 프로필 조회 API 응답 클래스
@JsonSerializable(includeIfNull: false)
class TalkProfile {
  /// 카카오톡 닉네임
  @JsonKey(name: "nickName")
  String? nickname;

  /// 카카오톡 프로필 이미지 URL
  @JsonKey(name: "profileImageURL")
  String? profileImageUrl;

  /// 카카오톡 프로필 이미지 썸네일 URL
  @JsonKey(name: "thumbnailURL")
  String? thumbnailUrl;

  /// 카카오톡 국가 코드
  String? countryISO;

  /// @nodoc
  TalkProfile(
      this.nickname, this.profileImageUrl, this.thumbnailUrl, this.countryISO);

  /// @nodoc
  factory TalkProfile.fromJson(Map<String, dynamic> json) =>
      _$TalkProfileFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$TalkProfileToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
