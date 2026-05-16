import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/models/user/user_light.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';
import 'package:taskflow_mobile/utils/dio_error_handler.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

class UserService {
  final Dio _dio = DioClient().dio;

  Future<UserLight> getUserProfile() async {
    try {
      final response = await _dio.get('/users/profile');
      return UserLight.fromJson(response.data);
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<List<UserDetailed>> getUsers() async {
    try{
      final response = await _dio.get('/users');
      List<dynamic> data = response.data;
      return data.map((json) => UserDetailed.fromJson(json)).toList();
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<UserLight> updateUserProfile({required String firstname, required String lastname,required String email}) async {
    try {
      final response = await _dio.patch('/users/profile', data: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
      }));
      return UserLight.fromJson(response.data);
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<UserLight> updateUserPassword({required String currentPassword, required String newPassword}) async {
    try {
      final response = await _dio.patch('/users/password', data: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword
      }));
      return UserLight.fromJson(response.data);
    } on DioException catch (e) {
      throwDioException(e);
    }
  }
}
