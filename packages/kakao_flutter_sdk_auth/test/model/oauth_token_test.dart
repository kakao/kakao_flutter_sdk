import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';
import 'package:kakao_flutter_sdk_auth/src/model/oauth_token.dart';

void main() {
  group('OAuthToken', () {
    test('should create OAuthToken from json', () {
      final json = {
        'access_token': 'test_access_token',
        'expires_at': '2026-01-01T00:00:00.000Z',
        'refresh_token': 'test_refresh_token',
        'refresh_token_expires_at': '2026-02-01T00:00:00.000Z',
        'scopes': ['profile', 'account_email'],
        'id_token': 'test_id_token',
      };

      final token = OAuthToken.fromJson(json);

      expect(token.accessToken, 'test_access_token');
      expect(token.refreshToken, 'test_refresh_token');
      expect(token.scopes, ['profile', 'account_email']);
      expect(token.idToken, 'test_id_token');
    });

    test('should serialize OAuthToken to json', () {
      final token = OAuthToken(
        'test_access_token',
        DateTime.parse('2026-01-01T00:00:00.000Z'),
        'test_refresh_token',
        DateTime.parse('2026-02-01T00:00:00.000Z'),
        ['profile', 'account_email'],
        idToken: 'test_id_token',
      );

      final json = token.toJson();

      expect(json['access_token'], 'test_access_token');
      expect(json['refresh_token'], 'test_refresh_token');
      expect(json['scopes'], ['profile', 'account_email']);
      expect(json['id_token'], 'test_id_token');
    });

    test('should create OAuthToken from AccessTokenResponse', () {
      final response = AccessTokenResponse(
        'test_access_token',
        3600,
        'test_refresh_token',
        5184000,
        'profile account_email',
        'bearer',
        idToken: 'test_id_token',
      );

      final token = OAuthToken.fromResponse(response);

      expect(token.accessToken, 'test_access_token');
      expect(token.refreshToken, 'test_refresh_token');
      expect(token.scopes, ['profile', 'account_email']);
      expect(token.idToken, 'test_id_token');
      expect(token.expiresAt.isAfter(DateTime.now()), true);
      expect(token.refreshTokenExpiresAt!.isAfter(DateTime.now()), true);
    });

    test(
      'should preserve old refresh token when response has no refresh token',
      () {
        final oldToken = OAuthToken(
          'old_access_token',
          DateTime.now().add(const Duration(hours: 1)),
          'old_refresh_token',
          DateTime.now().add(const Duration(days: 60)),
          ['profile'],
        );

        final response = AccessTokenResponse(
          'new_access_token',
          3600,
          null,
          null,
          null,
          'bearer',
        );

        final newToken = OAuthToken.fromResponse(response, oldToken: oldToken);

        expect(newToken.accessToken, 'new_access_token');
        expect(newToken.refreshToken, 'old_refresh_token');
        expect(newToken.scopes, ['profile']);
        expect(
          newToken.refreshTokenExpiresAt?.millisecondsSinceEpoch,
          oldToken.refreshTokenExpiresAt?.millisecondsSinceEpoch,
        );
      },
    );

    test('should handle null values correctly', () {
      final token = OAuthToken(
        'test_access_token',
        DateTime.now().add(const Duration(hours: 1)),
        null,
        null,
        null,
      );

      expect(token.accessToken, 'test_access_token');
      expect(token.refreshToken, null);
      expect(token.refreshTokenExpiresAt, null);
      expect(token.scopes, null);
      expect(token.idToken, null);
    });

    test('toString should return json string', () {
      final token = OAuthToken(
        'test_access_token',
        DateTime.now(),
        'test_refresh_token',
        DateTime.now(),
        ['profile'],
      );

      final str = token.toString();
      expect(str, contains('test_access_token'));
      expect(str, contains('test_refresh_token'));
    });
  });
}
