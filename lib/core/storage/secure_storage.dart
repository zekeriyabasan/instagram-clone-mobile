import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  static Future<void> saveUser({
    required String token,
    required int userId,
    required String username,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _usernameKey, value: username);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);

    if (value == null) {
      return null;
    }

    return int.tryParse(value);
  }

  static Future<String?> getUsername() async {
    return _storage.read(key: _usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    return (await getToken()) != null;
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
