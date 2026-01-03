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

  factory ProjectDetailed.fromJson(Map<String, dynamic> json) {
    return ProjectDetailed(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      isArchived: json['isArchived'],
      startAt: json['startAt'],
      endAt: json['endAt'],
      owner: User.fromJson(json['owner']),
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'title': title,
      'description': description,
      'isArchived': isArchived,
      'startAt': startAt,
      'endAt': endAt,
      'owner': owner.toJson(),
      'members': members.map((e) => e.toJson()).toList(),
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'tags': tags.map((e) => e.toJson()).toList(),
    };
  }
}