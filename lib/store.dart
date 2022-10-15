import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const storagess = FlutterSecureStorage();

  static const keyEmail = 'email';

  static const keyPassword = 'password';

  static Future setEmail(String email) async =>
      await storagess.write(key: keyEmail, value: email);

  static Future<String?> getEmail() async => await storagess.read(key: keyEmail);

    static Future setPassword(String password) async =>
      await storagess.write(key: keyPassword, value: password);

  static Future<String?> getPassword() async => await storagess.read(key: keyPassword);

}
