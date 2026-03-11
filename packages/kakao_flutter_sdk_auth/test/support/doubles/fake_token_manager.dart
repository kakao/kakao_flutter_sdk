import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';
import 'package:kakao_flutter_sdk_auth/src/token_manager.dart';

class FakeTokenManager implements TokenManager {
  OAuthToken? _token;

  @override
  Future<OAuthToken?> getToken() async => _token;

  @override
  Future<void> setToken(OAuthToken token) async {
    _token = token;
  }

  @override
  Future<void> clear() async {
    _token = null;
  }
}
