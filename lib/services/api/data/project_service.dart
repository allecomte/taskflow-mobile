import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/api/api_response_pagination.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';
import 'package:taskflow_mobile/utils/dio_error_handler.dart';

class ProjectService {
  final Dio _dio;

  ProjectService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<ApiResponsePagination<ProjectLight>> getProjects({
    bool pagination = false,
    int? page,
    int? limit,
    bool? getAlsoArchived,
    String? sort,
  }) async {
    try {
      final response = await _dio.get(
        '/projects',
        queryParameters: {
          'pagination': pagination,
          if (pagination && page != null) 'page': page,
          if (pagination && limit != null) 'limit': limit,
          if (getAlsoArchived != null && !getAlsoArchived)
            'isArchived': getAlsoArchived,
          if (sort != null) 'sort': sort,
        },
      );
      final result = ApiResponsePagination<ProjectLight>.fromJson(
        response.data,
        (json) => ProjectLight.fromJson(json as Map<String, dynamic>),
      );
      return result;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<ProjectDetailed> getProjectById(String projectId) async {
    try {
      final response = await _dio.get('/projects/$projectId');
      final project = ProjectDetailed.fromJson(response.data);
      return project;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<ProjectLight> createProject({
    required String title,
    required String description,
    required String startAt,
    String? endAt,
  }) async {
    try {
      final response = await _dio.post(
        '/projects',
        data: jsonEncode({
        'title': title,
        'description': description,
        'startAt': startAt,
        if(endAt != null) 'endAt': endAt,
      }),
        options: Options(contentType: Headers.jsonContentType),
      );
      final data = Map<String, dynamic>.from(response.data);
      final project = ProjectLight.fromJson(data);
      return project;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<ProjectDetailed> updateProject({
    required String id,
    required String title,
    required String description,
    required String startAt,
    String? endAt,
  }) async {
    try {
      final response = await _dio.patch(
        '/projects/$id',
        data: jsonEncode({
          'title': title,
          'description': description,
          'startAt': startAt,
          'endAt': endAt,
        }),
      );
      final project = ProjectDetailed.fromJson(response.data);
      return project;
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<void> addMemberToProject({
    required String projectId,
    required String userId,
  }) async {
    try {
      await _dio.post(
        '/projects/$projectId/members',
        data: jsonEncode({'member': userId}),
      );
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<void> removeMemberFromProject({
    required String projectId,
    required String userId,
  }) async {
    try {
      await _dio.delete('/projects/$projectId/members/$userId');
    } on DioException catch (e) {
      throwDioException(e);
    }
  }

  Future<void> deleteProject({required String projectId}) async {
    try {
      await _dio.delete('/projects/$projectId');
    } on DioException catch (e) {
      throwDioException(e);
    }
  }
}
