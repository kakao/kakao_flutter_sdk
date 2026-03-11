import '../auth_platform.dart';
import '../model/pkce.dart';
import '../model/prompt.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

/// @nodoc
class AuthPlatformImpl extends AuthPlatform {
  @override
  Future<String> authorizeWithTalk(
    String redirectUri,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) async {
    throw _notSupportedError();
  }

  @override
  Future<String> authorize(
    String redirectUri,
    List<Prompt>? prompts,
    String? loginHint,
    PKCE? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
  ) async {
    throw _notSupportedError();
  }

  @override
  Future<String> authorizeWithNewScopes(
    String agt,
    String redirectUri,
    List<String> scopes,
    PKCE? pkce,
    String? nonce,
  ) async {
    throw _notSupportedError();
  }

  @override
  Map<String, String> getPlatformData() {
    throw _notSupportedError();
  }

  @override
  Future<String> handleAppsUrl(
    String url, {
    String transId = '',
    String popupTitle = '',
  }) async {
    throw _notSupportedError();
  }

  KakaoClientException _notSupportedError() {
    return KakaoClientException.notSupported();
  }
}
