import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

/// 카카오계정에 등록된 사용자의 프로필 정보 제공
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Profile {
  /// 사용자의 닉네임
  final String? nickname;

  /// 카카오계정에 등록된 프로필 이미지의 썸네일 규격 이미지 URL
  final String? thumbnailImageUrl;

  /// 카카오계정에 등록된 프로필 이미지 URL
  final String? profileImageUrl;

  /// 카카오계정에 등록된 프로필 이미지가 기본이미지인지 여부
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
