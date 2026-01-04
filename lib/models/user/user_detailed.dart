import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/user/user.dart';

part 'user_detailed.g.dart';

@JsonSerializable()
class UserDetailed extends User{
  List<String> roles;

  UserDetailed({
    required super.id,
    required super.email,
    required super.firstname,
    required super.lastname,
    required this.roles
  });

  factory UserDetailed.fromJson(Map<String, dynamic> json) {
    return UserDetailed(
      id: json['_id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'roles': roles,
    };
  }
}