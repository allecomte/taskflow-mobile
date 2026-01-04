// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['_id'] as String,
  title: json['title'] as String,
  state: json['state'] as String,
  priority: json['priority'] as String,
  dueAt: json['dueAt'] as String,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'state': instance.state,
  'priority': instance.priority,
  'dueAt': instance.dueAt,
};
