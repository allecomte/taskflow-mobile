// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_light.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskLight _$TaskLightFromJson(Map<String, dynamic> json) => TaskLight(
  id: json['_id'] as String,
  title: json['title'] as String,
  state: json['state'] as String,
  priority: json['priority'] as String,
  dueAt: json['dueAt'] as String,
  assigneeId: json['assignee'] as String,
);

Map<String, dynamic> _$TaskLightToJson(TaskLight instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'state': instance.state,
  'priority': instance.priority,
  'dueAt': instance.dueAt,
  'assignee': instance.assigneeId,
};
