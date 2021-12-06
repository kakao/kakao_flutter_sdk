import 'dart:convert';

import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/common.dart';

part 'oauth_token.g.dart';

/// 카카오 로그인을 통해 발급 받은 토큰. Kakao SDK는 [TokenManager]를 통해 토큰을 자동으로 관리함.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class OAuthToken {
  /// API 인증에 사용하는 엑세스 토큰.
  String accessToken;

  /// 엑세스 토큰 만료 시각.
  DateTime accessTokenExpiresAt;

  /// 엑세스 토큰을 갱신하는데 사용하는 리프레시 토큰.
  String refreshToken;

  /// 리프레시 토큰 만료 시각.
  DateTime refreshTokenExpiresAt;

  /// 이 토큰에 부여된 scope 목록.
  List<String>? scopes;

  /// @nodoc
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

  /// @nodoc
  factory OAuthToken.fromJson(Map<String, dynamic> json) =>
      _$OAuthTokenFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$OAuthTokenToJson(this);

  /// @nodoc
  /// [AccessTokenResponse] 객체로부터 OAuthToken 객체 생성.
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
