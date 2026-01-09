import 'package:dio/dio.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class TagService {
  final Dio _dio = DioClient().dio;

  Future<void> createTag({required String projectId, required String name}) async {
    try {
      final result = await _dio.post('projects/$projectId/tags', data: {'name': name});
      print('🟩 RESULT | Tag created: $result');
    } on DioException catch (e) {
      throw Exception('Failed to create tag: ${e.message}');
    }
  }
}