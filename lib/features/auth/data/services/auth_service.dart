import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response.dart';

class AuthService {
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await DioClient.dio.post(
      ApiConstants.login,
      data: FormData.fromMap({
        "username": username,
        "password": password,
      }),
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return LoginResponse.fromJson(response.data);
  }
}