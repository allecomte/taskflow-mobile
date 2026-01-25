import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/models/user/user_light.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class UserService {
  final Dio _dio = DioClient().dio;

  Future<UserLight> getUserProfile() async {
    try {
      final response = await _dio.get('users/profile');
      return UserLight.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load user profile: ${e.message}');
    }
  }

  Future<List<UserDetailed>> getUsers() async {
    try{
      final response = await _dio.get('users');
      List<dynamic> data = response.data;
      return data.map((json) => UserDetailed.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load users: ${e.message}');
    }
  }
}
