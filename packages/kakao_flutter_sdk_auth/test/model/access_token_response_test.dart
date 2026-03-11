import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/constants.dart';
import 'package:kakao_flutter_sdk_auth/src/model/access_token_response.dart';

import '../../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';

void main() {
  group('AccessTokenInfo Test', () {
    void verifyJsonToModel(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.tokenPath);
        final body = await loadJson('auth/$path/$data.json');
        final expected = jsonDecode(body);
        final actual = AccessTokenResponse.fromJson(expected);

        expect(expected['access_token'], actual.accessToken);
        expect(expected['token_type'], actual.tokenType);
        expect(expected['refresh_token'], actual.refreshToken);
        expect(expected['expires_in'], actual.expiresIn);
        expect(
          expected['refresh_token_expires_in'],
          actual.refreshTokenExpiresIn,
        );
        expect(expected['scope'], actual.scope);
      });
    }

    verifyJsonToModel('has_rt');
    verifyJsonToModel('has_rt_and_scopes');
    verifyJsonToModel('no_rt');
  });

  group('AccessTokenResponse', () {
    test('should create AccessTokenResponse from json', () {
      final json = {
        'access_token': 'test_access_token',
        'expires_in': 3600,
        'refresh_token': 'test_refresh_token',
        'refresh_token_expires_in': 5184000,
        'scope': 'profile account_email',
        'token_type': 'bearer',
        'id_token': 'test_id_token',
      };

      final response = AccessTokenResponse.fromJson(json);

      expect(response.accessToken, 'test_access_token');
      expect(response.expiresIn, 3600);
      expect(response.refreshToken, 'test_refresh_token');
      expect(response.refreshTokenExpiresIn, 5184000);
      expect(response.scope, 'profile account_email');
      expect(response.tokenType, 'bearer');
      expect(response.idToken, 'test_id_token');
    });

    test('should serialize AccessTokenResponse to json', () {
      final response = AccessTokenResponse(
        'test_access_token',
        3600,
        'test_refresh_token',
        5184000,
        'profile account_email',
        'bearer',
        idToken: 'test_id_token',
      );

      final json = response.toJson();

      expect(json['access_token'], 'test_access_token');
      expect(json['expires_in'], 3600);
      expect(json['refresh_token'], 'test_refresh_token');
      expect(json['refresh_token_expires_in'], 5184000);
      expect(json['scope'], 'profile account_email');
      expect(json['token_type'], 'bearer');
      expect(json['id_token'], 'test_id_token');
    });

    test('should handle null values', () {
      final json = {
        'access_token': 'test_access_token',
        'expires_in': 3600,
        'token_type': 'bearer',
      };

      final response = AccessTokenResponse.fromJson(json);

      expect(response.accessToken, 'test_access_token');
      expect(response.expiresIn, 3600);
      expect(response.tokenType, 'bearer');
      expect(response.refreshToken, null);
      expect(response.refreshTokenExpiresIn, null);
      expect(response.scope, null);
      expect(response.idToken, null);
    });

    test('toString should return json string', () {
      final response = AccessTokenResponse(
        'test_access_token',
        3600,
        'test_refresh_token',
        5184000,
        'profile',
        'bearer',
      );

      final str = response.toString();
      expect(str, contains('test_access_token'));
      expect(str, contains('3600'));
      expect(str, contains('bearer'));
    });
  });
}
