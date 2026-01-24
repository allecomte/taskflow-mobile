enum TaskSortField { dueDate, createdAt, priority }

class TaskSort {
  final TaskSortField field;
  final bool ascending;

  const TaskSort({
    required this.field,
    this.ascending = true,
  });

  String get apiValue {
    final prefix = ascending ? '' : '-';
    switch (field) {
      case TaskSortField.dueDate:
        return '${prefix}dueAt';
      case TaskSortField.createdAt:
        return '${prefix}createdAt';
      case TaskSortField.priority:
        return '${prefix}priority';
    }
  }
}