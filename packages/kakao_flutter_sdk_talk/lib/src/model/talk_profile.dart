import 'package:json_annotation/json_annotation.dart';

part 'talk_profile.g.dart';

/// KO: 카카오톡 프로필
/// <br>
/// EN: Kakao Talk profile
@JsonSerializable(includeIfNull: false)
class TalkProfile {
  /// KO: 프로필 닉네임
  /// <br>
  /// EN: Profile nickname
  @JsonKey(name: "nickName")
  String? nickname;

  /// KO: 프로필 이미지
  /// <br>
  /// EN: Profile image
  @JsonKey(name: "profileImageURL")
  String? profileImageUrl;

  /// KO: 프로필 썸네일 이미지
  /// <br>
  /// EN: Profile thumbnail image
  @JsonKey(name: "thumbnailURL")
  String? thumbnailUrl;

  /// KO: 국가 코드
  /// <br>
  /// EN: Country code
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
