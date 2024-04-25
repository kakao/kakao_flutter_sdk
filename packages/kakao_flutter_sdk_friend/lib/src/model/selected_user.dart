import 'package:json_annotation/json_annotation.dart';

part 'selected_user.g.dart';

/// KO: 선택한 사용자 정보 목록
/// <br>
/// EN: A list of the selected user information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class SelectedUsers {
  @JsonKey(name: 'selectedTotalCount')

  /// KO: 선택한 사용자 수
  /// <br>
  /// EN: Number of selected users
  int totalCount;

  /// KO: 선택한 사용자 정보 목록, 정보 제공이 불가능한 사용자 제외
  /// <br>
  /// EN: A list of the selected user information, except for unavailable user information
  List<SelectedUser>? users;

  /// @nodoc
  SelectedUsers({required this.totalCount, this.users});

  /// @nodoc
  factory SelectedUsers.fromJson(Map<String, dynamic> json) =>
      _$SelectedUsersFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$SelectedUsersToJson(this);
}

/// KO: 선택한 사용자 정보
/// <br>
/// EN: Selected user information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class SelectedUser {
  /// KO: 회원번호, 앱과 연결된 사용자에게만 존재
  /// <br>
  /// EN: Service user ID, only provided for users linked with the app
  String? id;

  /// KO: 고유 ID
  /// <br>
  /// EN: Unique ID
  String uuid;

  /// KO: 프로필 닉네임
  /// <br>
  /// EN: Profile nickname
  String? profileNickname;

  /// KO: 프로필 썸네일 이미지
  /// <br>
  /// EN: Profile thumbnail image
  String? profileThumbnailImage;

  /// KO: 즐겨찾기 친구 여부
  /// <br>
  /// EN: Whether a favorite friend
  bool? favorite;

  /// @nodoc
  SelectedUser({
    this.id,
    required this.uuid,
    this.profileNickname,
    this.profileThumbnailImage,
    this.favorite,
  });

  /// @nodoc
  factory SelectedUser.fromJson(Map<String, dynamic> json) =>
      _$SelectedUserFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$SelectedUserToJson(this);
}
