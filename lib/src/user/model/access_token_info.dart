import 'package:json_annotation/json_annotation.dart';

part 'access_token_info.g.dart';

/// Accurate access token information from [UserApi.accessTokenInfo()].
@JsonSerializable(includeIfNull: false)
class AccessTokenInfo {
  /// <nodoc>
  AccessTokenInfo(this.appId, this.id, this.expiresInMillis);

  /// id of app this token belongs to.
  int appId;

  /// id of user this access token belongs to.
  int id;
  int expiresInMillis;

  /// <nodoc>
  factory AccessTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$AccessTokenInfoToJson(this);
}
