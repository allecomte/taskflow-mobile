import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';

void main() {
  late ProjectService projectService;

  setUpAll(() {
    final testDio = Dio(
      BaseOptions(
        baseUrl: 'https://6f79d3c8-857d-4ee7-ba31-20f902e69a5b.mock.pstmn.io/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    projectService = ProjectService(dio: testDio);
  });

  test('GET /projects returns projects', () async {
    final response = await projectService.getProjects();
    expect(response.data, isNotEmpty);
  });
}