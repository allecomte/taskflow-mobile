class Task {
  String title;
  String description;
  String dueAt;
  String priority;
  String state;
  String projectId;
  String assigneeId;

  Task({
    required this.title,
    required this.description,
    required this.dueAt,
    required this.priority,
    required this.state,
    required this.projectId,
    required this.assigneeId,
  });
}