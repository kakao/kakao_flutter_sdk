import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_sdk.dart';
import 'package:kakao_flutter_sdk_common/src/util.dart';

/// @nodoc
class Cipher {
  String encrypt(String value) {
    return '';
  }

  String decrypt(String encrypted) {
    return '';
  }
}

/// @nodoc
class AESCipher implements Cipher {
  static const _iterationCount = 10000;
  static const _keyLength = 32; // 256 bits
  static late Encrypter _encryptor;
  final IV _iv = IV(_initVector);
  static final Uint8List _initVector = Uint8List.fromList([
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

  AESCipher._();

  static Future<AESCipher> create() async {
    final cipher = AESCipher._();

    final keyValue = await KakaoSdk.origin;
    var salt = await platformId();

    var keySpec = Key(Uint8List.fromList(
        keyValue.substring(0, min(keyValue.length, 16)).codeUnits));
    var key = keySpec.stretch(_keyLength,
        iterationCount: _iterationCount, salt: salt);

    _encryptor = Encrypter(AES(key, mode: AESMode.cbc));
    return cipher;
  }

  @override
  String encrypt(String value) {
    return _encryptor.encrypt(value, iv: _iv).base64;
  }

  @override
  String decrypt(String encrypted) {
    return _encryptor.decrypt(Encrypted.fromBase64(encrypted), iv: _iv);
  }
}
