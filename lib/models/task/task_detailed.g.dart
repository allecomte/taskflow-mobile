// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDetailed _$TaskDetailedFromJson(Map<String, dynamic> json) => TaskDetailed(
  id: json['_id'] as String,
  state: json['state'] as String,
  priority: json['priority'] as String,
  dueAt: json['dueAt'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  project: ProjectLight.fromJson(json['project'] as Map<String, dynamic>),
  assignee: User.fromJson(json['assignee'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TaskDetailedToJson(TaskDetailed instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'state': instance.state,
      'priority': instance.priority,
      'dueAt': instance.dueAt,
      'description': instance.description,
      'project': instance.project,
      'assignee': instance.assignee,
    };
