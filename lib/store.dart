import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const storages = FlutterSecureStorage();

  static const keyEmail = 'email';

  static const keyPassword = 'password';

  static Future setEmail(String email) async =>
      await storages.write(key: keyEmail, value: email);

  static Future<String?> getEmail() async => await storages.read(key: keyEmail);

    static Future setPassword(String password) async =>
      await storages.write(key: keyPassword, value: password);

  static Future<String?> getPassword() async => await storages.read(key: keyPassword);

}
