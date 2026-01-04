import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  @JsonKey(name: '_id')
  String id;
  String title;
  String state;
  String priority;
  String dueAt;

  Task({required this.id, required this.title, required this.state, required this.priority, required this.dueAt});

  factory Task.fromJson(Map<String, dynamic> json) =>
      _$TaskFromJson(json);

      Map<String, dynamic> toJson() => _$TaskToJson(this);
}
