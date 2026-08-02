class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String username;

  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      userId: json['user_id'],
      username: json['username'],
    );
  }
}