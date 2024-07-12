import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';

part 'oauth_token.g.dart';

/// KO: 카카오 로그인으로 발급받은 토큰
/// <br>
/// EN: Tokens issued with Kakao Login
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class OAuthToken {
  /// KO: 액세스 토큰
  /// <br>
  /// EN: Access token
  String accessToken;

  /// KO: 액세스 토큰 만료시각
  /// <br>
  /// EN: The expiration time of the access token
  DateTime expiresAt;

  /// KO: 리프레시 토큰
  /// <br>
  /// EN: Refresh token
  String? refreshToken;

  /// KO: 리프레시 토큰 만료시각
  /// <br>
  /// EN: The expiration time of the refresh token
  DateTime? refreshTokenExpiresAt;

  /// KO: 인가된 동의항목
  /// <br>
  /// EN: Authorized scopes
  List<String>? scopes;

  /// KO: ID 토큰
  /// <br>
  /// EN: ID token
  String? idToken;

  /// @nodoc
  OAuthToken(this.accessToken, this.expiresAt, this.refreshToken,
      this.refreshTokenExpiresAt, this.scopes,
      {this.idToken});

  /// @nodoc
  factory OAuthToken.fromJson(Map<String, dynamic> json) =>
      _$OAuthTokenFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$OAuthTokenToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();

  /// @nodoc
  /// [AccessTokenResponse] 객체로부터 OAuthToken 객체 생성
  static OAuthToken fromResponse(AccessTokenResponse response,
      {OAuthToken? oldToken}) {
    final atExpiresAt =
        DateTime.now().millisecondsSinceEpoch + response.expiresIn * 1000;

    String? refreshToken;
    int? rtExpiresAt;

    if (response.refreshToken != null) {
      refreshToken = response.refreshToken;
      if (refreshToken != null && response.refreshTokenExpiresIn != null) {
        rtExpiresAt = DateTime.now().millisecondsSinceEpoch +
            response.refreshTokenExpiresIn! * 1000;
      }
    } else {
      refreshToken = oldToken?.refreshToken;
      rtExpiresAt = oldToken?.refreshTokenExpiresAt?.millisecondsSinceEpoch;
    }

    List<String>? scopes;
    if (response.scope != null) {
      scopes = response.scope!.split(' ');
    } else {
      scopes = oldToken?.scopes;
    }
    return OAuthToken(
      response.accessToken,
      DateTime.fromMillisecondsSinceEpoch(atExpiresAt),
      refreshToken,
      rtExpiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(rtExpiresAt)
          : null,
      scopes,
      idToken: response.idToken,
    );
  }
}
