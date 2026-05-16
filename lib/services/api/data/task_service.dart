import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/api/api_response_pagination.dart';
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';
import 'package:taskflow_mobile/utils/dio_error_handler.dart';

class TaskService {
  final Dio _dio = DioClient().dio;

  Future<ApiResponsePagination<TaskLight>> getTasks({
    bool pagination = false,
    int? page,
    int? limit,
    bool? notClosed,
    String? sort,
    String? state,
    String? priority,
    String? tag,
    String? assignee,
    String? dueBefore,
    String? dueAfter,
    bool? onlyMine,
  }) async {
    try {
      final response = await _dio.get(
        '/tasks',
        queryParameters: {
          'pagination': pagination,
          if (pagination && page != null) 'page': page,
          if (pagination && limit != null) 'limit': limit,
          if (notClosed != null) 'notClosed': notClosed,
          if (sort != null) 'sort': sort,
          if (state != null) 'state': state,
          if (priority != null) 'priority': priority,
          if (tag != null) 'tag': tag,
          if (assignee != null) 'assignee': assignee,
          if (dueBefore != null) 'dueAt[lte]': dueBefore,
          if (dueAfter != null) 'dueAt[gte]': dueAfter,
          if (onlyMine != null && onlyMine) 'onlyMine': onlyMine,
        },
      );
      final result = ApiResponsePagination<TaskLight>.fromJson(
        response.data,
        (json) => TaskLight.fromJson(json as Map<String, dynamic>),
      );
      return result;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<TaskDetailed> getTaskById(String taskId) async {
    try{
      final response = await _dio.get('/tasks/$taskId');
      final task = TaskDetailed.fromJson(response.data);
      return task;
    }on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<TaskDetailed> createTask({
    required String title,
    required String description,
    required String dueAt,
    required String priority,
    required String project,
    required String assignee,
    List<String>? tags,
  }) async {
    try {
      final response = await _dio.post(
        '/tasks',
        data: jsonEncode({
          'title': title,
          'description': description,
          'dueAt': dueAt,
          'priority': priority,
          'project': project,
          'assignee': assignee,
          'tags': tags ?? [],
        }),
        options: Options(contentType: Headers.jsonContentType),
      );
      final data = Map<String, dynamic>.from(response.data);
      final task = TaskDetailed.fromJson(data);
      return task;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<TaskDetailed> updateTask({
    required String id,
    required String title,
    required String description,
    required String dueAt,
    required String priority,
    required String assignee,
    List<String>? tags,
  }) async {
    try {
      final response = await _dio.patch(
        '/tasks/$id',
        data: jsonEncode({
          'title': title,
          'description': description,
          'dueAt': dueAt,
          'priority': priority,
          'assignee': assignee,
          'tags': tags ?? [],
        }),
      );
      final task = TaskDetailed.fromJson(response.data);
      return task;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<TaskDetailed> updateTaskState({
    required String id,
    required String state
  }) async {
    try {
      final response = await _dio.patch(
        '/tasks/$id',
        data: jsonEncode({
          'state': state
        }),
      );
      final task = TaskDetailed.fromJson(response.data);
      return task;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<void> deleteTask({required String taskId}) async {
    try {
      await _dio.delete('/tasks/$taskId');
    } on DioException catch (e) {
      throwDioException(e);
    }
  }
}
