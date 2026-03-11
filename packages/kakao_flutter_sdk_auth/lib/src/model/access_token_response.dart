import 'package:json_annotation/json_annotation.dart';

part 'access_token_response.g.dart';

/// @nodoc
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AccessTokenResponse {
  final String accessToken;
  final int expiresIn;
  final String? refreshToken;
  final int? refreshTokenExpiresIn;
  final String? scope;
  final String tokenType;
  final String? idToken;

  AccessTokenResponse(this.accessToken, this.expiresIn, this.refreshToken,
      this.refreshTokenExpiresIn, this.scope, this.tokenType,
      {this.idToken});

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);

  @override
  String toString() => toJson().toString();
}
