import 'package:json_annotation/json_annotation.dart';

part 'talk_profile.g.dart';

@JsonSerializable(includeIfNull: false)
class TalkProfile {
  /// <nodoc>
  TalkProfile(
      this.nickname, this.profileImageUrl, this.thumbnailUrl, this.countryISO);
  @JsonKey(name: "nickName")
  String nickname;
  @JsonKey(name: "profileImageURL")
  Uri profileImageUrl;
  @JsonKey(name: "thumbnailURL")
  Uri thumbnailUrl;
  String countryISO;

  /// <nodoc>
  factory TalkProfile.fromJson(Map<String, dynamic> json) =>
      _$TalkProfileFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TalkProfileToJson(this);
}
