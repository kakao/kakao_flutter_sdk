import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/account.dart';
import 'package:kakao_flutter_sdk_user/src/model/user.dart';

part 'user_response.g.dart';

/// @nodoc
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class UserResponse {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  int id;

  /// KO: 사용자 프로퍼티
  /// <br>
  /// EN: User properties
  Map<String, String>? properties;

  /// KO: 카카오계정 정보
  /// <br>
  /// EN: Kakao Account information
  Account? kakaoAccount;

  /// KO: 그룹에서 맵핑 정보로 사용할 수 있는 값
  /// <br>
  /// EN: Token to map users in the group apps
  String? groupUserToken;

  /// KO: 서비스에 연결 완료된 시각, UTC
  /// <br>
  /// EN: Time connected to the service, UTC
  DateTime? connectedAt;

  /// KO: 카카오싱크 간편가입을 통해 로그인한 시각, UTC
  /// <br>
  /// EN: Time logged in through Kakao Sync Simple Signup, UTC
  DateTime? synchedAt;

  /// KO: 수동 연결 API 호출의 완료 여부
  /// <br>
  /// EN: Whether the user is completely linked with the app
  bool? hasSignedUp;

  /// KO: 카카오 및 공동체, 제휴 앱에만 제공되는 추가 정보
  /// <br>
  /// EN: Additional user information for Kakao and partners
  ForPartner? forPartner;

  /// @nodoc
  UserResponse(this.id, this.hasSignedUp, this.properties, this.kakaoAccount,
      this.groupUserToken, this.synchedAt, this.connectedAt, this.forPartner);

  /// @nodoc
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();

  User toUser() {
    return User(id, hasSignedUp, properties, kakaoAccount, groupUserToken,
        synchedAt, connectedAt, forPartner?.uuid);
  }
}

/// @nodoc
/// KO: 사용자 정보 조회 응답
/// <br>
/// EN: Response for Retrieve user information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ForPartner {
  String? uuid;

  /// @nodoc
  ForPartner(this.uuid);

  /// @nodoc
  factory ForPartner.fromJson(Map<String, dynamic> json) =>
      _$ForPartnerFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ForPartnerToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
