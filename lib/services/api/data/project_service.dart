import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/api/api_response_pagination.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class ProjectService {
  final Dio _dio = DioClient().dio;

  Future<ApiResponsePagination<ProjectLight>> getProjects({bool pagination = false , int? page, int? limit, bool? getAlsoArchived, String? sort}) async {
    try {
      final response = await _dio.get('projects', queryParameters: {
        'pagination': pagination,
        if (pagination && page != null) 'page': page,
        if (pagination && limit != null) 'limit': limit,
        if (getAlsoArchived != null && !getAlsoArchived) 'isArchived': getAlsoArchived,
        if (sort != null) 'sort': sort,
      });
      final result = ApiResponsePagination<ProjectLight>.fromJson(response.data, (json) => ProjectLight.fromJson(json as Map<String, dynamic>));
       return result;
    } on DioException catch (e) {
      throw Exception('Failed to load projects: ${e.message}');
    }
  }  
}