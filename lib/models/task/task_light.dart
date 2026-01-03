import 'package:json_annotation/json_annotation.dart';

part 'task_light.g.dart';

@JsonSerializable()
class TaskLight {
  @JsonKey(name: '_id')
  final String id;
  final String state;
  final String project;

  TaskLight({required this.id, required this.state, required this.project});

  factory TaskLight.fromJson(Map<String, dynamic> json) =>
      _$TaskLightFromJson(json);

      Map<String, dynamic> toJson() => _$TaskLightToJson(this);
}
