import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorage{
  static const _storage = FlutterSecureStorage();
  static const _keyDBPassword = "db_password";
  static Future setDBPassword(String password) async{
    await _storage.write(key: _keyDBPassword, value: password);
  }

  static Future<String?> getDBPassword() async{
    return await _storage.read(key: _keyDBPassword);
  }
}