import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authServiceProvider));
});

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<void> {
  late final AuthRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.read(authRepositoryProvider);
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.login(
        username: username,
        password: password,
      );

      await SecureStorage.saveUser(
        token: response.accessToken,
        userId: response.userId,
        username: response.username,
      );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    await SecureStorage.logout();
    state = const AsyncData(null);
  }
}
