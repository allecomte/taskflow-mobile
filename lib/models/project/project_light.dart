import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/project/project.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';

part 'project_light.g.dart';

@JsonSerializable()
class ProjectLight extends Project {
  final List<String> tasks;
  final List<TaskLight> myTasks;

  ProjectLight({
    required super.id,
    required super.title,
    required super.description,
    required super.startAt,
    super.endAt,
    this.tasks = const [],
    this.myTasks = const [],
  });

  factory ProjectLight.fromJson(Map<String, dynamic> json) {
    return ProjectLight(
      id: json['_id'],
      title: json['title'],
      description: json['description'] as String? ?? '',
      startAt: json['startAt'],
      endAt: json['endAt'] as String? ?? '',
      tasks:
          (json['tasks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      myTasks:
          (json['myTasks'] as List<dynamic>?)
              ?.map((e) => TaskLight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'tasks': tasks,
      'myTasks': myTasks.map((e) => e.toJson()).toList(),
    };
  }
}
