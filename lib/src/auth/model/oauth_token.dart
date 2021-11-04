import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/auth/model/access_token_response.dart';
import 'package:kakao_flutter_sdk/src/common/kakao_error.dart';

part 'oauth_token.g.dart';

/// Access token and refresh token information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class OAuthToken {
  String accessToken;

  /// Use this field with caution. Token might have expired on server side.
  DateTime accessTokenExpiresAt;
  String refreshToken;

  /// Use this field with caution. Token might have expired on server side.
  DateTime refreshTokenExpiresAt;

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

  static OAuthToken fromResponse(AccessTokenResponse response,
      {OAuthToken? oldToken}) {
    final atExpiresAt =
        DateTime.now().millisecondsSinceEpoch + response.expiresIn * 1000;

    var refreshToken;
    var rtExpiresAt;

    if (response.refreshToken != null) {
      refreshToken = response.refreshToken;
      if (refreshToken != null && response.refreshTokenExpiresIn != null) {
        rtExpiresAt = DateTime.now().millisecondsSinceEpoch +
            response.refreshTokenExpiresIn! * 1000;
      }
    } else {
      refreshToken = oldToken != null
          ? oldToken.refreshToken
          : throw KakaoClientException(
              'Refresh token not found in the response.');
      rtExpiresAt = oldToken.refreshTokenExpiresAt.millisecondsSinceEpoch;
    }

    var scopes;
    if (response.scope != null) {
      scopes = response.scope!.split(' ');
    } else {
      scopes = oldToken?.scopes;
    }
    return OAuthToken(
        response.accessToken,
        DateTime.fromMillisecondsSinceEpoch(atExpiresAt),
        refreshToken,
        DateTime.fromMillisecondsSinceEpoch(rtExpiresAt),
        scopes);
  }
}
