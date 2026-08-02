import '../models/login_response.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) {
    return _service.login(username: username, password: password);
  }
}
