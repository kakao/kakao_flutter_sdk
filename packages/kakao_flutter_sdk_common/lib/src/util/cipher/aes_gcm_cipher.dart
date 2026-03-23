import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

import 'cipher.dart';

/// @nodoc
class AesGcmCipher extends Cipher {
  AesGcmCipher._(this._encrypter);

  static Cipher create(
    String keyValue,
    Uint8List salt, {
    int iterationCount = 10_000,
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

    final encryptor = Encrypter(AES(key, mode: AESMode.gcm));
    return AesGcmCipher._(encryptor);
  }

  final Encrypter _encrypter;
  final _ivLength = 12; // 96 bits, recommended for GCM

  @override
  String encrypt(String value) {
    final iv = IV.fromSecureRandom(_ivLength);
    final encrypted = _encrypter.encrypt(value, iv: iv);

    final combined = Uint8List(iv.bytes.length + encrypted.bytes.length)
      ..setRange(0, iv.bytes.length, iv.bytes)
      ..setRange(
        iv.bytes.length,
        iv.bytes.length + encrypted.bytes.length,
        encrypted.bytes,
      );
    return base64Encode(combined);
  }

  @override
  String decrypt(String encrypted) {
    final combined = base64Decode(encrypted);
    final ivLength = _ivLength;
    if (combined.length <= ivLength) {
      throw ArgumentError('Encrypted payload is too short.');
    }

    final iv = IV(combined.sublist(0, ivLength));
    final cipherBytes = combined.sublist(ivLength);
    return _encrypter.decrypt(Encrypted(cipherBytes), iv: iv);
  }
}
