enum TaskSortField { dueDate, createdAt, priority }

class TaskSort {
  final TaskSortField field;
  final bool ascending;

  const TaskSort({
    required this.field,
    required this.ascending,
  });

  static const TaskSort defaultSort = TaskSort(
    field: TaskSortField.dueDate,
    ascending: true,
  );

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

  String get label {
    switch (field) {
      case TaskSortField.dueDate:
        return 'Date d’échéance';
      case TaskSortField.createdAt:
        return 'Date de création';
      case TaskSortField.priority:
        return 'Priorité';
    }
  }

  String get directionLabel => ascending ? 'Croissant' : 'Décroissant';
}