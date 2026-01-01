import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/project/project.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class ProjectService {
  final Dio _dio = DioClient().dio;

  Future<List<Project>> getProjects() async {
    try {
      final response = await _dio.get('projects');
      final List<dynamic> data = response.data;
      return data.map((json) => Project.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load projects: ${e.message}');
    }
  }  
}