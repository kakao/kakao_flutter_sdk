import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

/// KO: 프로필 정보
/// <br>
/// EN: Profile information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Profile {
  /// KO: 닉네임
  /// <br>
  /// EN: Nickname
  final String? nickname;

  /// KO: 프로필 미리보기 이미지 URL
  /// <br>
  /// EN: Thumbnail image URL
  final String? thumbnailImageUrl;

  /// KO: 프로필 사진 URL
  /// <br>
  /// EN: Profile image URL
  final String? profileImageUrl;

  /// KO: 프로필 사진 URL이 기본 프로필 사진 URL인지 여부
  /// <br>
  /// EN: Whether the default image is used for profile image
  final bool? isDefaultImage;

  /// @nodoc
  Profile(this.nickname, this.thumbnailImageUrl, this.profileImageUrl,
      this.isDefaultImage);

  /// @nodoc
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
