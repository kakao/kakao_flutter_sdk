import 'dart:convert';

import 'package:crypto/crypto.dart';

/// @nodoc
class PKCE {
  PKCE(this.codeVerifier) : codeChallenge = _codeChallenge(codeVerifier);

  final String codeVerifier;
  final String codeChallenge;
  final String codeChallengeMethod = 'S256';

  static String _codeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}
