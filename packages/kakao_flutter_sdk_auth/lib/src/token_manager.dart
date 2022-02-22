import 'dart:convert';

import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kakao SDK가 사용하게 될 토큰 저장소 제공자
///
/// Kakao SDK는 로그인에 성공하면 이 제공자를 통해 현재 지정된 토큰 저장소에 토큰 저장
/// 저장된 토큰은 로그인 기반 API 호출 시 자동으로 인증 헤더에 추가됨
///
/// [DefaultTokenManager]를 기본 저장소로 사용하며, 토큰을 직접 관리하고 싶은 경우 [TokenManager] 인터페이스를 구현하여 나만의 저장소 설정 가능
/// 앱 서비스 도중 저장소 구현을 변경하는 경우, 앱 업데이트 사용자를 위하여 기존에 저장되어 있던 토큰 마이그레이션 고려해야 함
///
/// ```dart
/// // 사용자 정의 저장소 설정하기
/// TokenManagerProvider.instance.manager = MyTokenManager();
/// ```
class TokenManagerProvider {
  /// 현재 지정된 토큰 저장소
  /// 기본 값 [DefaultTokenManager._instance]
  TokenManager manager = DefaultTokenManager();

  /// singleton 객체
  static final instance = TokenManagerProvider();
}

/// 카카오 API에 사용되는 액세스 토큰, 리프레시 토큰을 관리하는 추상 클래스
abstract class TokenManager {
  /// 토큰([token])를 저장
  Future<void> setToken(OAuthToken token);

  /// 저장되어 있는 [OAuthToken] 반환
  Future<OAuthToken?> getToken();

  /// 저장되어 있는 [OAuthToken] 객체를 삭제
  Future<void> clear();
}

/// Kakao SDK에서 기본 제공하는 토큰 저장소 구현체
///
/// 기기 고유값을 이용해 토큰을 암호화하고 [SharedPreferences]에 저장함
/// (Android는 SharedPreferences, iOS는 UserDefaults에 저장함)
class DefaultTokenManager implements TokenManager {
  static const tokenKey = "com.kakao.token.OAuthToken";
  static const atKey = "com.kakao.token.AccessToken";
  static const atExpiresAtKey = "com.kakao.token.AccessToken.ExpiresAt";
  static const rtKey = "com.kakao.token.RefreshToken";
  static const rtExpiresAtKey = "com.kakao.token.RefreshToken.ExpiresAt";
  static const secureModeKey = "com.kakao.token.KakaoSecureMode";
  static const scopesKey = "com.kakao.token.Scopes";

  static final _instance = DefaultTokenManager._();

  DefaultTokenManager._();

  factory DefaultTokenManager() {
    return _instance;
  }

  @override
  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(tokenKey);
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(tokenKey, jsonEncode(token));
  }

  @override
  Future<OAuthToken?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var jsonToken = preferences.getString(tokenKey);

    if (jsonToken == null) {
      return await _migrateOldToken();
    }
    return OAuthToken.fromJson(jsonDecode(jsonToken));
  }

  // Token management logic has been changed from 0.9.0 version.
  // This code has been added for compatibility with previous versions.
  Future<OAuthToken?> _migrateOldToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString(atKey);
    var refreshToken = preferences.getString(rtKey);
    var atExpiresAtMillis = preferences.getInt(atExpiresAtKey);
    var rtExpiresAtMillis = preferences.getInt(rtExpiresAtKey);
    List<String>? scopes = preferences.getStringList(scopesKey);

    // If token that issued before 0.9.0 version are loaded, then return OAuthToken.
    if (accessToken != null &&
        refreshToken != null &&
        atExpiresAtMillis != null &&
        rtExpiresAtMillis != null) {
      SdkLog.i("=== Migrate from old version token ===");

      var accessTokenExpiresAt =
          DateTime.fromMillisecondsSinceEpoch(atExpiresAtMillis);
      var refreshTokenExpiresAt =
          DateTime.fromMillisecondsSinceEpoch(rtExpiresAtMillis);

      final token = OAuthToken(accessToken, accessTokenExpiresAt, refreshToken,
          refreshTokenExpiresAt, scopes);

      // Remove all token properties that saved before 0.9.0 version and save migrated token.
      await preferences.remove(atKey);
      await preferences.remove(atExpiresAtKey);
      await preferences.remove(rtKey);
      await preferences.remove(rtExpiresAtKey);
      await preferences.remove(secureModeKey);
      await preferences.remove(scopesKey);
      await preferences.setString(tokenKey, jsonEncode(token));
      return token;
    }
    return null;
  }
}
