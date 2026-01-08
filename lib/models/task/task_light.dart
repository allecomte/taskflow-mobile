import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/task/task.dart';

part 'task_light.g.dart';

@JsonSerializable()
class TaskLight extends Task {
  @JsonKey(name: 'assignee')
  String assigneeId;
  TaskLight({
    required super.id,
    required super.title,
    required super.state,
    required super.priority,
    required super.dueAt,
    required this.assigneeId,
  });

  factory TaskLight.fromJson(Map<String, dynamic> json) {
    return TaskLight(
      id: json['_id'],
      title: json['title'],
      state: json['state'],
      priority: json['priority'],
      dueAt: json['dueAt'],
      assigneeId: json['assignee'],
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
      'assignee': assigneeId,
    };
  }
}