import 'package:json_annotation/json_annotation.dart';

part 'talk_profile.g.dart';

@JsonSerializable(includeIfNull: false)
class TalkProfile {
  @JsonKey(name: "nickName")
  String? nickname;
  @JsonKey(name: "profileImageURL")
  String? profileImageUrl;
  @JsonKey(name: "thumbnailURL")
  String? thumbnailUrl;
  String? countryISO;

  /// <nodoc>
  TalkProfile(
      this.nickname, this.profileImageUrl, this.thumbnailUrl, this.countryISO);

  /// <nodoc>
  factory TalkProfile.fromJson(Map<String, dynamic> json) =>
      _$TalkProfileFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$TalkProfileToJson(this);
}
