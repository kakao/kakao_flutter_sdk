import 'package:json_annotation/json_annotation.dart';

part 'access_token_info.g.dart';

/// KO: 액세스 토큰 정보
/// <br>
/// EN: Access token information
@JsonSerializable(includeIfNull: false)
class AccessTokenInfo {
  /// KO: 앱 ID
  /// <br>
  /// EN: App ID
  @JsonKey(name: 'app_id')
  int appId;

  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  int? id;

  /// KO: 만료 시간(단위: 초)
  /// <br>
  /// EN: Remaining expiration time (Unit: second)
  @JsonKey(name: "expires_in")
  int expiresIn;

  /// @nodoc
  AccessTokenInfo(this.appId, this.id, this.expiresIn);

  /// @nodoc
  factory AccessTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$AccessTokenInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
