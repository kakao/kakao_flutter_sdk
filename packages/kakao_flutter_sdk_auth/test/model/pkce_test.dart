import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/src/model/pkce.dart';

void main() {
  group('PKCE', () {
    test('should create PKCE with code verifier', () {
      final pkce = PKCE('test_code_verifier');

      expect(pkce.codeVerifier, 'test_code_verifier');
      expect(pkce.codeChallenge, isNotEmpty);
      expect(pkce.codeChallengeMethod, 'S256');
    });

    test('should generate correct code challenge using SHA256', () {
      final pkce = PKCE('dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk');

      // This is a known test vector from RFC 7636
      expect(pkce.codeChallenge, 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM');
      expect(pkce.codeChallengeMethod, 'S256');
    });

    test('should generate different challenges for different verifiers', () {
      final pkce1 = PKCE('verifier1');
      final pkce2 = PKCE('verifier2');

      expect(pkce1.codeChallenge, isNot(equals(pkce2.codeChallenge)));
    });

    test('should generate same challenge for same verifier', () {
      final pkce1 = PKCE('same_verifier');
      final pkce2 = PKCE('same_verifier');

      expect(pkce1.codeChallenge, equals(pkce2.codeChallenge));
    });

    test('code challenge should not contain padding', () {
      final pkce = PKCE('test_verifier');

      expect(pkce.codeChallenge, isNot(contains('=')));
    });

    test('should keep fields available for platform mapping', () {
      final pkce = PKCE('test_code_verifier');

      expect(pkce.codeVerifier, 'test_code_verifier');
      expect(pkce.codeChallenge, isNotEmpty);
      expect(pkce.codeChallengeMethod, 'S256');
    });

    test('code challenge should be base64url encoded', () {
      final pkce = PKCE('test_verifier');

      // Base64url should only contain alphanumeric, -, and _
      final regex = RegExp(r'^[A-Za-z0-9\-_]+$');
      expect(regex.hasMatch(pkce.codeChallenge), true);
    });
  });
}
