import 'package:json_annotation/json_annotation.dart';

part 'access_token_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AccessTokenResponse {
  AccessTokenResponse(this.accessToken, this.expiresIn, this.refreshToken,
      this.refreshTokenExpiresIn, this.scopes, this.tokenType);

  String accessToken;
  int expiresIn;
  String refreshToken;
  int refreshTokenExpiresIn;
  @JsonKey(name: "scope")
  String scopes;
  String tokenType;

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}
