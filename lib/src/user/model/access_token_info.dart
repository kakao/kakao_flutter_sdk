import 'package:json_annotation/json_annotation.dart';

part 'access_token_info.g.dart';

/// Accurate access token information from [UserApi.accessTokenInfo()].
@JsonSerializable(includeIfNull: false)
class AccessTokenInfo {
  /// id of app this token belongs to.
  @JsonKey(name: 'app_id')
  int appId;

  /// id of user this access token belongs to.
  int? id;
  @JsonKey(name: "expires_in")
  int expiresIn;

  /// Replaced with property 'expiresIn' using 'second' units.
  @deprecated
  int? expiresInMillis;

  /// <nodoc>
  AccessTokenInfo(this.appId, this.id, this.expiresIn, this.expiresInMillis);

  /// <nodoc>
  factory AccessTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$AccessTokenInfoToJson(this);
}
