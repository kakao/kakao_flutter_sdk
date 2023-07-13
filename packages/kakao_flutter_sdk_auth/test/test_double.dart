import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

OAuthToken testOAuthToken(
    {String accessToken = 'test_access_token',
    required DateTime expiresAt,
    String refreshToken = 'test_refresh_token',
    required DateTime refreshTokenExpiresAt,
    List<String>? scopes = const ['profile']}) {
  return OAuthToken(
    accessToken,
    expiresAt,
    refreshToken,
    refreshTokenExpiresAt,
    scopes,
  );
}

class TestTokenManager implements TokenManager {
  OAuthToken? _token;

  TestTokenManager(OAuthToken token) {
    _token = token;
  }

  @override
  Future clear() async {
    _token = null;
  }

  @override
  Future<OAuthToken?> getToken() async {
    return _token;
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    _token = token;
  }
}

void registerMockMethodChannel() {
  var channel = const MethodChannel(CommonConstants.methodChannel);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (message) async {
    if (message.method == 'platformId') {
      return Uint8List.fromList([1, 2, 3, 4, 5]);
    }
    return 'sample_origin';
  });
}

void registerMockSharedPreferencesMethodChannel() {
  var sharedPreferencesChannel =
      const MethodChannel('plugins.flutter.io/shared_preferences');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(sharedPreferencesChannel, (message) async {
    if (message.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    if (message.method.startsWith("set") || message.method == 'remove') {
      return true;
    }
    return null;
  });
}
