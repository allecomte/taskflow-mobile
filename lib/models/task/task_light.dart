import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/models/user/user.dart';

part 'task_light.g.dart';

@JsonSerializable()
class TaskLight extends Task {
  final User? assignee;
  TaskLight({
    required super.id,
    required super.title,
    required super.state,
    required super.priority,
    required super.dueAt,
    this.assignee,
  });

  factory TaskLight.fromJson(Map<String, dynamic> json) {
    return TaskLight(
      id: json['_id'],
      title: json['title'],
      state: json['state'],
      priority: json['priority'],
      dueAt: json['dueAt'],
      assignee: json['assignee'] != null ? User.fromJson(json['assignee']) : null,
    );
  }
  @override
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'title': title,
      'state': state,
      'priority': priority,
      'dueAt': dueAt,
      'assignee': assignee?.id,
    };
  }
}