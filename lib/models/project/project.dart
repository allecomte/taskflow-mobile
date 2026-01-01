import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  @JsonKey(name: '_id')
  String id;
  String title;
  String description;
  bool isArchived;
  String startAt;
  String? endAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.isArchived = false,
    required this.startAt,
    this.endAt
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}