import 'package:json_annotation/json_annotation.dart';

part 'talk_profile.g.dart';

@JsonSerializable()
class TalkProfile {
  TalkProfile(
      this.nickname, this.profileImageUrl, this.thumbnailUrl, this.countryISO);
  @JsonKey(name: "nickName")
  String nickname;
  @JsonKey(name: "profileImageURL")
  String profileImageUrl;
  @JsonKey(name: "thumbnailURL")
  String thumbnailUrl;
  String countryISO;

  factory TalkProfile.fromJson(Map<String, dynamic> json) =>
      _$TalkProfileFromJson(json);
  Map<String, dynamic> toJson() => _$TalkProfileToJson(this);
}
