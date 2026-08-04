import '../models/login_response.dart';
import '../models/register_response.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);
  
  Future<RegisterResponse> register({
  required String username,
  required String email,
  required String password,
}) {
  return _service.register(
    username: username,
    email: email,
    password: password,
  );
}

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) {
    return _service.login(username: username, password: password);
  }
}
