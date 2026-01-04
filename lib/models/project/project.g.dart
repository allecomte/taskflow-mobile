// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  id: json['_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  isArchived: json['isArchived'] as bool? ?? false,
  startAt: json['startAt'] as String,
  endAt: json['endAt'] as String?,
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'isArchived': instance.isArchived,
  'startAt': instance.startAt,
  'endAt': instance.endAt,
};
