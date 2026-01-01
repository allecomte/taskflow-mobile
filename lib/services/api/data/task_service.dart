import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class TaskService {
 final Dio _dio = DioClient().dio;
 Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('tasks');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Task.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load tasks: ${e.message}');
    }
  }
}