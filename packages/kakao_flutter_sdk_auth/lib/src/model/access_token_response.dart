import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

part 'access_token_response.g.dart';

/// @nodoc
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AccessTokenResponse {
  String accessToken;
  int expiresIn;
  String? refreshToken;
  int? refreshTokenExpiresIn;
  String? scope;
  String tokenType;
  String? txId;

  AccessTokenResponse(this.accessToken, this.expiresIn, this.refreshToken,
      this.refreshTokenExpiresIn, this.scope, this.tokenType,
      {this.txId});

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);

  @override
  String toString() => toJson().toString();
}
