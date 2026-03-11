import 'package:json_annotation/json_annotation.dart';

import 'account.dart';

part 'user.g.dart';

/// KO: 사용자 정보 조회 응답
/// <br>
/// EN: Response for Retrieve user information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class User {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  final int id;

  /// KO: 사용자 프로퍼티
  /// <br>
  /// EN: User properties
  final Map<String, String>? properties;

  /// KO: 카카오계정 정보
  /// <br>
  /// EN: Kakao Account information
  final Account? kakaoAccount;

  /// KO: 그룹에서 맵핑 정보로 사용할 수 있는 값
  /// <br>
  /// EN: Token to map users in the group apps
  final String? groupUserToken;

  /// KO: 서비스에 연결 완료된 시각, UTC
  /// <br>
  /// EN: Time connected to the service, UTC
  final DateTime? connectedAt;

  /// KO: 카카오싱크 간편가입을 통해 로그인한 시각, UTC
  /// <br>
  /// EN: Time logged in through Kakao Sync Simple Signup, UTC
  final DateTime? synchedAt;

  /// KO: 수동 연결 API 호출의 완료 여부
  /// <br>
  /// EN: Whether the user is completely linked with the app
  final bool? hasSignedUp;

  /// KO: 다른 사용자의 친구 정보에서 보여지는 해당 사용자의 고유 ID
  /// <br>
  /// EN: Unique ID for the friend information
  final String? uuid;

  /// @nodoc
  User(this.id, this.hasSignedUp, this.properties, this.kakaoAccount,
      this.groupUserToken, this.synchedAt, this.connectedAt, this.uuid);

  /// @nodoc
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
