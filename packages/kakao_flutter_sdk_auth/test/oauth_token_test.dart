import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

import 'test_double.dart';

void main() {
  test('serialize', () async {
    DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 12);
    DateTime refreshTokenExpiresAt = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 24 * 30 * 2);

    OAuthToken token = testOAuthToken(
      expiresAt: expiresAt,
      refreshTokenExpiresAt: refreshTokenExpiresAt,
      scopes: ['account_email', 'legal_age'],
    );

    String serialized = jsonEncode(token.toJson());
    OAuthToken deserialized = OAuthToken.fromJson(jsonDecode(serialized));

    expect(token.accessToken, deserialized.accessToken);
    expect(token.refreshToken, deserialized.refreshToken);
    expect(token.expiresAt, deserialized.expiresAt);
    expect(token.refreshTokenExpiresAt, deserialized.refreshTokenExpiresAt);
    expect(token.scopes, deserialized.scopes);
  });
}
