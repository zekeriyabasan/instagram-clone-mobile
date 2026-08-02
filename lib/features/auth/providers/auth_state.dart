class AuthState {
  final bool isLoggedIn;
  final String? username;
  final int? userId;

  const AuthState({required this.isLoggedIn, this.username, this.userId});

  factory AuthState.loggedOut() {
    return const AuthState(isLoggedIn: false);
  }

  factory AuthState.loggedIn({required String username, required int userId}) {
    return AuthState(isLoggedIn: true, username: username, userId: userId);
  }
}
