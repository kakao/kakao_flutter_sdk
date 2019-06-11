import 'dart:convert';

class AccessToken {
  AccessToken(this.accessToken, this.accessTokenExpiresAt, this.refreshToken,
      this.refreshTokenExpiresAt, this.scopes);

  String accessToken;
  DateTime accessTokenExpiresAt;
  String refreshToken;
  DateTime refreshTokenExpiresAt;
  List<String> scopes;

  @override
  String toString() {
    return jsonEncode({
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "scopes": scopes
    });
  }
}
