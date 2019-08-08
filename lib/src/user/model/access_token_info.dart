import 'package:json_annotation/json_annotation.dart';

part 'access_token_info.g.dart';

@JsonSerializable(includeIfNull: false)
class AccessTokenInfo {
  AccessTokenInfo(this.appId, this.id, this.expiresInMillis);

  int appId;
  int id;
  int expiresInMillis;

  factory AccessTokenInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenInfoToJson(this);
}
