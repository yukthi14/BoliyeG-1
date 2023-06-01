import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

class MessageEncryption {
  var key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);

  Encrypted encryptText(text) {
    final encrypted = encrypt.Encrypter(encrypt.AES(key));

    return encrypted.encrypt(text, iv: iv);
  }

  String decryptText(text) {
    List<int> decodeByte = base64.decode(text);
    Uint8List bytes = Uint8List.fromList(decodeByte);
    Encrypted byte = Encrypted(bytes);

    final decoder = encrypt.Encrypter(encrypt.AES(key));
    return decoder.decrypt(byte, iv: iv);
  }
}
