import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'oauth_token.g.dart';

/// Access token and refresh token information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class OAuthToken {
  String? accessToken;

  /// Use this field with caution. Token might have expired on server side.
  DateTime? accessTokenExpiresAt;
  String? refreshToken;

  /// Use this field with caution. Token might have expired on server side.
  DateTime? refreshTokenExpiresAt;

  /// List of scopes this user has agreed to when this token was issued.
  List<String>? scopes;

  OAuthToken(this.accessToken, this.accessTokenExpiresAt, this.refreshToken,
      this.refreshTokenExpiresAt, this.scopes);

  @override
  String toString() {
    return jsonEncode({
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "scopes": scopes
    });
  }

  /// <nodoc>
  factory OAuthToken.fromJson(Map<String, dynamic> json) =>
      _$OAuthTokenFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$OAuthTokenToJson(this);
}
