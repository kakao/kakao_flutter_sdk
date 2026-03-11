import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

KakaoResponse buildTokenResponse(OAuthToken token) {
  final now = DateTime.now();
  final expiresIn = _secondsUntil(token.expiresAt, now);
  final refreshExpiresIn = token.refreshTokenExpiresAt == null
      ? null
      : _secondsUntil(token.refreshTokenExpiresAt!, now);

  final response = <String, dynamic>{
    'access_token': token.accessToken,
    'expires_in': expiresIn,
    'token_type': 'bearer',
  };

  if (token.refreshToken != null) {
    response['refresh_token'] = token.refreshToken;
  }

  if (refreshExpiresIn != null) {
    response['refresh_token_expires_in'] = refreshExpiresIn;
  }

  if (token.scopes != null) {
    response['scope'] = token.scopes!.join(' ');
  }

  if (token.idToken != null) {
    response['id_token'] = token.idToken;
  }

  return KakaoResponse(statusCode: 200, data: response, headers: const {});
}

int _secondsUntil(DateTime value, DateTime now) {
  final diff = value.difference(now).inSeconds;
  return diff <= 0 ? 1 : diff;
}
