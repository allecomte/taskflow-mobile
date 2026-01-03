import 'package:dio/dio.dart';
import 'package:taskflow_mobile/models/api/api_response_pagination.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/services/api/dio_client.dart';

class TaskService {
 final Dio _dio = DioClient().dio;
 Future<ApiResponsePagination<Task>> getTasks({bool pagination = false , int? page, int? limit, bool? notClosed, String? sort, String? state, String? priority, String? tag, String? assignee, String? dueAt}) async {
    try {
      final response = await _dio.get('tasks', queryParameters: {
        'pagination': pagination,
        if (pagination && page != null) 'page': page,
        if (pagination && limit != null) 'limit': limit,
        if (notClosed != null && notClosed) 'notClosed': notClosed,
        if (sort != null) 'sort': sort,
        if (state != null) 'state': state,
        if (priority != null) 'priority': priority,
        if (tag != null) 'tag': tag,
        if (assignee != null) 'assignee': assignee,
        if (dueAt != null) 'dueAt': dueAt,
      });
      print('TASKS RESPONSE');
      print(response.data);
      final result = ApiResponsePagination<Task>.fromJson(response.data, (json) => Task.fromJson(json as Map<String, dynamic>));
       return result;
    } on DioException catch (e) {
      throw Exception('Failed to load tasks: ${e.message}');
    }
  }
}