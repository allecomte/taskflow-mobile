import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';
import 'package:taskflow_mobile/utils/dio_error_handler.dart';

class TagService {
  final Dio _dio = DioClient().dio;

  Future<Tag> createTag({required String projectId, required String name}) async {
    try {
      final result = await _dio.post('/projects/$projectId/tags', data: {'name': name});
      final tag = Tag.fromJson(result.data);
      return tag;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<Tag> updateTag({required String tagId, required String name}) async {
    try {
      final result = await _dio.patch('/tags/$tagId', data: {'name': name});
      final tag = Tag.fromJson(result.data);
      return tag;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<void> deleteTag({required String tagId})async {
    try{
      await _dio.delete('/tags/$tagId');
    }on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<void> associateOrDissociateTagWithTask({required String taskId,required String tagId}) async {
    try {
      await _dio.post('/tasks/$taskId/tags/$tagId');
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<List<Tag>> getTagsByProject({required String projectId}) async {
    try{
      final response = await _dio.get('/projects/$projectId/tags');
      final List<dynamic> data = response.data;
      return data.map((json) => Tag.fromJson(json)).toList();
    }on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<List<Tag>> getTags() async {
    try{
      final response = await _dio.get('/tags');
      final List<dynamic> data = response.data;
      return data.map((json) => Tag.fromJson(json)).toList();
    }on DioException catch (e) {
      throwDioException(e);
    }
  }
}