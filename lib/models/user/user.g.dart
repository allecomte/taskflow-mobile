// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['_id'] as String,
  email: json['email'] as String,
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  '_id': instance.id,
  'email': instance.email,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
};
