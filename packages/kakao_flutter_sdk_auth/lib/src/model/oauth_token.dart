import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

part 'oauth_token.g.dart';

/// 카카오 로그인을 통해 발급 받은 토큰, Kakao SDK는 [TokenManager]를 통해 토큰을 자동으로 관리함
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class OAuthToken {
  /// API 인증에 사용하는 엑세스 토큰
  String accessToken;

  /// 엑세스 토큰 만료 시각
  @Deprecated('This property will be replaced by \'expiresAt\' from 1.2.0')
  DateTime accessTokenExpiresAt;

  /// 엑세스 토큰 만료 시각
  DateTime expiresAt;

  /// 엑세스 토큰을 갱신하는데 사용하는 리프레시 토큰
  String refreshToken;

  /// 리프레시 토큰 만료 시각
  DateTime refreshTokenExpiresAt;

  /// 이 토큰에 부여된 scope 목록
  List<String>? scopes;

  /// OpenID Connect 확장 기능을 통해 발급되는 ID 토큰, Base64 인코딩된 사용자 인증 정보 포함
  String? idToken;

  /// @nodoc
  OAuthToken(this.accessToken, this.accessTokenExpiresAt, this.expiresAt,
      this.refreshToken, this.refreshTokenExpiresAt, this.scopes,
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
      refreshToken = oldToken != null
          ? oldToken.refreshToken
          : throw KakaoClientException(
              'Refresh token not found in the response.');
      rtExpiresAt = oldToken.refreshTokenExpiresAt.millisecondsSinceEpoch;
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
      DateTime.fromMillisecondsSinceEpoch(atExpiresAt),
      refreshToken!,
      DateTime.fromMillisecondsSinceEpoch(rtExpiresAt!),
      scopes,
      idToken: response.idToken,
    );
  }
}
