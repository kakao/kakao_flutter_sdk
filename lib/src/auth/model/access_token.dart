class AccessToken {
  AccessToken(this.accessToken, this.accessTokenExpiresAt, this.refreshToken,
      this.refreshTokenExpiresAt, this.scopes);

  String accessToken;
  DateTime accessTokenExpiresAt;
  String refreshToken;
  DateTime refreshTokenExpiresAt;
  List<String> scopes;
}
