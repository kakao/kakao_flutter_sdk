import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Profile {
  final String? nickname;
  final String? thumbnailImageUrl;
  final String? profileImageUrl;
  final bool? isDefaultImage;

  /// <nodoc>
  Profile(this.nickname, this.thumbnailImageUrl, this.profileImageUrl,
      this.isDefaultImage);

  /// <nodoc>
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
