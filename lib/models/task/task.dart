import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  @JsonKey(name: '_id')
  String id;
  String title;
  String description;
  String dueAt;
  String priority;
  String state;
  @JsonKey(name: 'project')
  String projectId;
  @JsonKey(name: 'assignee')
  String assigneeId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.priority,
    required this.state,
    required this.projectId,
    required this.assigneeId,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
