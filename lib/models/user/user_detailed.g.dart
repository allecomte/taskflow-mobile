// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailed _$UserDetailedFromJson(Map<String, dynamic> json) => UserDetailed(
  id: json['_id'] as String,
  email: json['email'] as String,
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  projectsMemberOf:
      (json['projectsMemberOf'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  tasksAssigned:
      (json['tasksAssigned'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserDetailedToJson(UserDetailed instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'roles': instance.roles,
      'projectsMemberOf': instance.projectsMemberOf,
      'tasksAssigned': instance.tasksAssigned,
    };
