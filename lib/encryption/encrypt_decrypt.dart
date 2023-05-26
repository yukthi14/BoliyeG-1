import 'package:encrypt/encrypt.dart' as encrypt;

class MessageEncryption {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));
  static encryptText(text) {
    return encrypter.encrypt(text, iv: iv);
  }

  static decryptText(text) {
    return encrypter.decrypt(text, iv: iv);
  }
}
