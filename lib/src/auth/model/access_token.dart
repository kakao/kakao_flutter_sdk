import 'dart:convert';

/// Access token and refresh token information.
class AccessToken {
  AccessToken(this.accessToken, this.accessTokenExpiresAt, this.refreshToken,
      this.refreshTokenExpiresAt, this.scopes);

  String accessToken;

  /// Use this field with caution. Token might have expired on server side.
  DateTime accessTokenExpiresAt;
  String refreshToken;

  /// Use this field with caution. Token might have expired on server side.
  DateTime refreshTokenExpiresAt;

  /// List of scopes this user has agreed to when this token was issued.
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
