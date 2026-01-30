import 'package:taskflow_mobile/models/api/api_response_pagination.dart';
import 'package:taskflow_mobile/models/api/pagination.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';

class FakeProjectService extends ProjectService {
  FakeProjectService(this.result);

  final Future<List<ProjectLight>> Function() result;

  @override
  Future<ApiResponsePagination<ProjectLight>> getProjects({
    bool pagination = false,
    int? page,
    int? limit,
    bool? getAlsoArchived,
    String? sort,
  }) async {
    final projects = await result();
    if (projects.isEmpty) {
      return ApiResponsePagination<ProjectLight>(
        data: [],
        pagination: Pagination(
          total: 0,
          totalPages: 1,
          page: 1,
          limit: 0,
          hasNextPage: false,
          hasPrevPage: false,
        ),
      );
    }
    final currentPage = page ?? 1;
    final pageLimit = limit ?? projects.length;

    final start = (currentPage - 1) * pageLimit;
    final end = start + pageLimit;

    final paginatedData = projects.sublist(
      start,
      end > projects.length ? projects.length : end,
    );

    final totalPages = (projects.length / pageLimit).ceil();
    return ApiResponsePagination<ProjectLight>(
      data: pagination ? paginatedData : projects,
      pagination: Pagination(
        total: projects.length,
        totalPages: totalPages,
        page: currentPage,
        limit: pageLimit,
        hasNextPage: currentPage < totalPages,
        hasPrevPage: currentPage > 1,
      ),
    );
  }
}
