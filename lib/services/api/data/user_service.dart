import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class UserService {
  final Dio _dio = DioClient().dio;
  
   Future<User> getUserProfile() async {
    try {
      final response = await _dio.get('users/profile');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load user profile: ${e.message}');
    }
  }
}