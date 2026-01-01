// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  dueAt: json['dueAt'] as String,
  priority: json['priority'] as String,
  state: json['state'] as String,
  projectId: json['project'] as String,
  assigneeId: json['assignee'] as String,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'dueAt': instance.dueAt,
  'priority': instance.priority,
  'state': instance.state,
  'project': instance.projectId,
  'assignee': instance.assigneeId,
};
