// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_light.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectLight _$ProjectLightFromJson(Map<String, dynamic> json) => ProjectLight(
  id: json['_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  startAt: json['startAt'] as String,
  endAt: json['endAt'] as String?,
  tasks:
      (json['tasks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  myTasks:
      (json['myTasks'] as List<dynamic>?)
          ?.map((e) => TaskLight.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
)..isArchived = json['isArchived'] as bool;

Map<String, dynamic> _$ProjectLightToJson(ProjectLight instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isArchived': instance.isArchived,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
      'tasks': instance.tasks,
      'myTasks': instance.myTasks,
    };
