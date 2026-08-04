import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response.dart';
import '../models/register_response.dart';

class AuthService {
  Future<RegisterResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final url = "${DioClient.dio.options.baseUrl}${ApiConstants.register}";
      print("URL => $url");
      final response = await DioClient.dio.post(
        ApiConstants.register,
        data: {"username": username, "email": email, "password": password},
      );

      print(response.data);

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");
      print("Message: ${e.message}");
      rethrow;
    }
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await DioClient.dio.post(
      ApiConstants.login,
      data: FormData.fromMap({"username": username, "password": password}),
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return LoginResponse.fromJson(response.data);
  }
}
