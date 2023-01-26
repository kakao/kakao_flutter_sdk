import 'package:json_annotation/json_annotation.dart';

part 'selected_user.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class SelectedUsers {
  @JsonKey(name: 'selectedTotalCount')
  int totalCount;
  List<SelectedUser>? users;

  SelectedUsers({required this.totalCount, this.users});

  factory SelectedUsers.fromJson(Map<String, dynamic> json) =>
      _$SelectedUsersFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedUsersToJson(this);
}

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class SelectedUser {
  String? id;
  String uuid;
  String? profileNickname;
  String? profileThumbnailImage;
  bool? favorite;

  SelectedUser({
    this.id,
    required this.uuid,
    this.profileNickname,
    this.profileThumbnailImage,
    this.favorite,
  });

  factory SelectedUser.fromJson(Map<String, dynamic> json) =>
      _$SelectedUserFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedUserToJson(this);
}
