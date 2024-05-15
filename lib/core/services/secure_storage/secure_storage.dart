import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SecureStorage {
  static const String refreshToken = 'refreshToken';
  static const String userId = 'userId';
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  SecureStorage();

  write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  Future remove(String key) async {
    return await storage.delete(key: key);
  }
}
