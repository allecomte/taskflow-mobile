import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String id;
  String email;
  String firstname;
  String lastname;
  List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
