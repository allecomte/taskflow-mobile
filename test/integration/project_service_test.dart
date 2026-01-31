import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
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
    expect(response.data, isA<List<ProjectLight>>());
    expect(response.data.first.id, isNotEmpty);
    expect(response.data.first.title, isNotNull);
  });

  test('GET /projects/:id returns detailed project', () async {
    // On récupère d’abord un projet existant
    final projects = await projectService.getProjects();
    if (projects.data.isEmpty) return; // rien à tester si aucun projet

    final projectId = projects.data.first.id;
    final detailed = await projectService.getProjectById(projectId);

    expect(detailed, isA<ProjectDetailed>());
    expect(detailed.id, equals(projectId));
    expect(detailed.title, isNotNull);
  });

  test('POST /projects create a project', () async {
    final project = await projectService.createProject(
      title: 'Project One',
      description: 'Description for Project One',
      startAt: '2026-01-01T10:00:00.720+00:00',
    );
    expect(project.id, isNotEmpty);
    expect(project.title, isNotNull);
  });

  test('PATCH /projects/:id updates a project', () async {
    final projects = await projectService.getProjects();
    if (projects.data.isEmpty) return;

    final project = projects.data.first;
    final updated = await projectService.updateProject(
      id: project.id,
      title: '${project.title} updated',
      description: project.description,
      startAt: project.startAt,
    );

    expect(updated, isA<ProjectDetailed>());
    expect(updated.id, equals(project.id));
    expect(updated.title, isNotNull);
  });

  test('POST /projects/:id/members adds a member', () async {
    final projects = await projectService.getProjects();
    if (projects.data.isEmpty) return;

    final projectId = projects.data.first.id;
    // On utilise un id de test
    await projectService.addMemberToProject(
      projectId: projectId,
      userId: '697b37fd1bbb4a181fd7f429',
    );

    expect(true, isTrue);
  });

  test('DELETE /projects/:id removes a project', () async {
    // La suppression ne retourne rien mais ne doit pas lancer d’exception
    await projectService.deleteProject(projectId: '697cebdba052b9d285428c0d');

    expect(true, isTrue);
  });
}
