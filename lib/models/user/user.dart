import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String id;
  String email;
  String firstname;
  String lastname;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromDetailed(UserDetailed user){
    return User(
      id: user.id,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email
    );
  }
}
