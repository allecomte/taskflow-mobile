import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/user/user.dart';

part 'user_light.g.dart';

@JsonSerializable()
class UserLight extends User{
  List<String> roles;
  List<String> projectsOwned;

  UserLight({
    required super.id,
    required super.email,
    required super.firstname,
    required super.lastname,
    this.roles = const [],
    this.projectsOwned = const [],
  });

  factory UserLight.fromJson(Map<String, dynamic> json) {
    return UserLight(
      id: json['_id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      projectsOwned: (json['projectsOwned'] as List<dynamic>?)
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
      'projectsOwned': roles,
    };
  }

  UserLight copyWith({
    String? email,
    String? firstname,
    String? lastname,
    List<String>? roles,
    List<String>? projectsOwned,
  }) {
    return UserLight(
      id: id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      roles: roles ?? this.roles,
      projectsOwned: projectsOwned ?? this.projectsOwned,
    );
  }
}