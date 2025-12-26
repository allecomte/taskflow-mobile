import 'package:dio/dio.dart';
import 'package:taskflow_mobile/services/api/api_exception.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class AuthApi {
  final Dio _dio = DioClient().dio;

  Future<String> login({required String email, required String password}) async {
    try{
      final response = await _dio.post(
      'users/login',
      data: {'email': email, 'password': password},
    );
    return response.data['token'];
    }on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Identifiants invalides';
      throw ApiException(message);
    }
    
  }
}
