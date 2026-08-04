class RegisterResponse {
  final String username;
  final String email;

  RegisterResponse({required this.username, required this.email});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(username: json["username"], email: json["email"]);
  }
}
