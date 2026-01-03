// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_light.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskLight _$TaskLightFromJson(Map<String, dynamic> json) => TaskLight(
  id: json['_id'] as String,
  state: json['state'] as String,
  project: json['project'] as String,
);

Map<String, dynamic> _$TaskLightToJson(TaskLight instance) => <String, dynamic>{
  '_id': instance.id,
  'state': instance.state,
  'project': instance.project,
};
