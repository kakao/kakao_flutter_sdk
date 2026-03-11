import 'model/pkce.dart';
import 'model/prompt.dart';
import 'platform/auth_platform_stub.dart'
    if (dart.library.io) 'platform/auth_platform_native.dart'
    if (dart.library.html) 'web/auth_platform_web.dart';

/// @nodoc
abstract class AuthPlatform {
  static final AuthPlatform instance = AuthPlatformImpl();

  Future<String> authorizeWithTalk(
    String redirectUri,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  );

  Future<String> authorize(
    String redirectUri,
    List<Prompt>? prompts,
    String? loginHint,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  );

  Future<String> authorizeWithNewScopes(
    String agt,
    String redirectUri,
    List<String> scopes,
    PKCE? pkce,
    String? nonce,
  );

  Map<String, String> getPlatformData();

  Future<String> handleAppsUrl(
    String url, {
    String transId = '', // 웹 전용 파라미터
    String popupTitle = '', // 웹 전용 파라미터
  });
}
