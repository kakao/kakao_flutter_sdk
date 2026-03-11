import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

/// @nodoc
abstract class Cipher {
  String encrypt(String value);

  String decrypt(String encrypted);
}

/// @nodoc
class AESCipher extends Cipher {
  AESCipher._(this._encrypter);

  static Cipher create(
    String keyValue,
    Uint8List salt, {
    int iterationCount = 100,
    int keyLength = 32, // 256 bits
  }) {
    final keySpec = Key(
      Uint8List.fromList(
        keyValue.substring(0, min(keyValue.length, 16)).codeUnits,
      ),
    );
    final key = keySpec.stretch(
      keyLength,
      iterationCount: iterationCount,
      salt: salt,
    );

    final encryptor = Encrypter(AES(key, mode: AESMode.cbc));
    return AESCipher._(encryptor);
  }

  final IV _iv = IV(_initVector);

  final Encrypter _encrypter;

  @override
  String encrypt(String value) {
    return _encrypter.encrypt(value, iv: _iv).base64;
  }

  @override
  String decrypt(String encrypted) {
    return _encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: _iv);
  }

  static final _initVector = Uint8List.fromList([
    112,
    78,
    75,
    55,
    -54,
    -30,
    -10,
    44,
    102,
    -126,
    -126,
    92,
    -116,
    -48,
    -123,
    -55,
  ]);
}
