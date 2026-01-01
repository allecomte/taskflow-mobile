import 'package:json_annotation/json_annotation.dart';
import 'package:taskflow_mobile/models/project/project.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/models/user/user.dart';

part 'project_detailed.g.dart';

@JsonSerializable()
class ProjectDetailed extends Project {
  final User owner;
  final List<User> members;
  final List<Task> tasks;
  final List<Tag> tags;

  ProjectDetailed({
    required super.id,
    required super.title,
    required super.description,
    required super.isArchived,
    required super.startAt,
    super.endAt,
    required this.owner,
    this.members = const [],
    this.tasks = const [],
    this.tags = const [],
  });

  factory ProjectDetailed.fromJson(Map<String, dynamic> json) => _$ProjectDetailedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProjectDetailedToJson(this);
}