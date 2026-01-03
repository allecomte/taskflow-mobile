// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDetailed _$ProjectDetailedFromJson(Map<String, dynamic> json) =>
    ProjectDetailed(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isArchived: json['isArchived'] as bool,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String?,
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tasks:
          (json['tasks'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProjectDetailedToJson(ProjectDetailed instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isArchived': instance.isArchived,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
      'owner': instance.owner,
      'members': instance.members,
      'tasks': instance.tasks,
      'tags': instance.tags,
    };
