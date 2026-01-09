// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_light.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLight _$UserLightFromJson(Map<String, dynamic> json) => UserLight(
  id: json['_id'] as String,
  email: json['email'] as String,
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UserLightToJson(UserLight instance) => <String, dynamic>{
  '_id': instance.id,
  'email': instance.email,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'roles': instance.roles,
};
