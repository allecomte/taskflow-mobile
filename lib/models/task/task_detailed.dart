import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/models/user/user.dart';

part 'task_detailed.g.dart';

@JsonSerializable()
class TaskDetailed extends Task {
  String description;
  @JsonKey(name: 'project')
  ProjectLight project;
  @JsonKey(name: 'assignee')
  User assignee;
  final List<Tag> tags;

  TaskDetailed({
    required super.id,
    required super.title,
    required this.description,
    required super.dueAt,
    required super.priority,
    required super.state,
    required this.project,
    required this.assignee,
    this.tags = const []
  });

  factory TaskDetailed.fromJson(Map<String, dynamic> json) {
    return TaskDetailed(
      id: json['_id'],
      state: json['state'],
      priority: json['priority'],
      dueAt: json['dueAt'],
      title: json['title'],
      description: json['description'],
      project: ProjectLight.fromJson(json['project']),
      assignee: User.fromJson(json['assignee']),
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'state': state,
      'priority': priority,
      'dueAt': dueAt,
      'title': title,
      'description': description,
      'project': project.toJson(),
      'assignee': assignee.toJson(),
      'tags': tags.map((e) => e.toJson()).toList(),
    };
  }
}
